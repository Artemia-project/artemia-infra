import os
import requests
import subprocess
import sys
import json
import textwrap

GEMINI_API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent"

def get_pr_diff(pr_number: str) -> str:
    """Fetches the diff of a given pull request number from GitHub."""
    try:
        diff_output = subprocess.check_output(
            ["gh", "pr", "diff", pr_number], text=True, stderr=subprocess.PIPE
        )
        return diff_output
    except subprocess.CalledProcessError as e:
        print(f"Error fetching PR diff: {e.stderr}", file=sys.stderr)
        sys.exit(1)

def get_review_from_gemini(diff: str, api_key: str) -> str:
    """
    Sends a diff to the Gemini API and returns a code review.
    """
    headers = {
        "Content-Type": "application/json",
        "x-goog-api-key": api_key,
    }
    prompt = textwrap.dedent(f"""
        You are a senior software engineer performing a code review.
        Please provide a concise and constructive code review for the following diff from a pull request.
        Please provide the review in Korean.

        {diff}
        """)
    data = {"contents": [{"parts": [{"text": prompt}]}]}

    try:
        response = requests.post(GEMINI_API_URL, headers=headers, data=json.dumps(data))
        response.raise_for_status()
        # Safely extract the review text
        content = response.json()
        review_text = content.get("candidates", [{}])[0].get("content", {}).get("parts", [{}])[0].get("text")
        if not review_text:
            print("Error: Could not extract review from Gemini API response.", file=sys.stderr)
            print(f"Full response: {content}", file=sys.stderr)
            sys.exit(1)
        return review_text
    except requests.exceptions.RequestException as e:
        print(f"Error calling Gemini API: {e}", file=sys.stderr)
        sys.exit(1)
    except (KeyError, IndexError) as e:
        print(f"Error parsing Gemini API response: {e}", file=sys.stderr)
        print(f"Full response: {response.text}", file=sys.stderr)
        sys.exit(1)


def post_review_comment(pr_number: str, review: str):
    """Posts a comment to a GitHub pull request."""
    try:
        subprocess.run(
            ["gh", "pr", "comment", pr_number, "--body", review],
            check=True,
            text=True,
            capture_output=True,
        )
    except subprocess.CalledProcessError as e:
        print(f"Error posting comment to PR: {e.stderr}", file=sys.stderr)
        sys.exit(1)

def main():
    """
    Main function to run the code review process.
    """
    gemini_api_key = os.getenv("GEMINI_API_KEY")
    if not gemini_api_key:
        print("Error: GEMINI_API_KEY environment variable not set.", file=sys.stderr)
        sys.exit(1)

    if len(sys.argv) < 2:
        print("Error: Pull request number not provided.", file=sys.stderr)
        print("Usage: python code_review.py <PR_NUMBER>", file=sys.stderr)
        sys.exit(1)

    pr_number = sys.argv[1]

    print(f"Fetching diff for PR #{pr_number}...")
    diff_output = get_pr_diff(pr_number)

    print("Requesting review from Gemini...")
    review = get_review_from_gemini(diff_output, gemini_api_key)

    print(f"Posting review to PR #{pr_number}...")
    post_review_comment(pr_number, review)

    print("Code review comment posted successfully.")

if __name__ == "__main__":
    main()
