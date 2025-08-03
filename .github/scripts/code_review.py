import os
import requests
import subprocess
import sys
import json
import textwrap

LLM_API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent"

def get_last_review_comment_time(pr_number: str) -> str:
    """마지막 코드리뷰 댓글의 시간을 가져옴"""
    try:
        # 코드리뷰 형식(Good/Bad/Action Suggestion)을 포함한 댓글 검색
        comments_output = subprocess.check_output([
            "gh", "pr", "view", pr_number, "--json", "comments", 
            "--jq", ".comments[] | select(.body | contains(\"Good:\") and contains(\"Bad:\") and contains(\"Action Suggestion:\")) | .createdAt"
        ], text=True, stderr=subprocess.PIPE)
        
        comments = comments_output.strip().split('\n') if comments_output.strip() else []
        return comments[-1].strip('"') if comments else ""
    except subprocess.CalledProcessError:
        return ""

def has_new_commits_since_last_review(pr_number: str) -> bool:
    """마지막 코드리뷰 이후 새로운 커밋이 있는지 확인"""
    last_review_time = get_last_review_comment_time(pr_number)
    
    if not last_review_time:
        # 이전 리뷰가 없으면 리뷰 필요
        return True
    
    try:
        # 마지막 리뷰 시간 이후의 커밋들 조회
        new_commits_output = subprocess.check_output([
            "gh", "pr", "view", pr_number, "--json", "commits",
            "--jq", f".commits[] | select(.committedDate > \"{last_review_time}\") | .oid"
        ], text=True, stderr=subprocess.PIPE)
        
        new_commits = new_commits_output.strip().split('\n') if new_commits_output.strip() else []
        return len([c for c in new_commits if c]) > 0
        
    except subprocess.CalledProcessError as e:
        print(f"Warning: Could not check for new commits: {e.stderr}", file=sys.stderr)
        return True  # 확인할 수 없으면 리뷰하는 것으로 가정

def get_pr_diff(pr_number: str) -> str:
    """GitHub에서 PR의 diff를 가져옴"""
    try:
        diff_output = subprocess.check_output(
            ["gh", "pr", "diff", pr_number], text=True, stderr=subprocess.PIPE
        )
        return diff_output.strip()
    except subprocess.CalledProcessError as e:
        print(f"Error fetching PR diff: {e.stderr}", file=sys.stderr)
        sys.exit(1)

def get_review_from_llm(diff: str, api_key: str) -> str:
    """
    diff를 LLM API에 전송하여 코드리뷰 결과를 받아옴
    """
    headers = {
        "Content-Type": "application/json",
        "x-goog-api-key": api_key,
    }
    prompt = textwrap.dedent(f"""
        You are a senior software engineer performing a code review.
        Please provide a concise and constructive code review for the following diff from a pull request.
        Please provide the review in Korean, focusing on the 3 most important points.
        Think step by step.
        
        =====Format=====
        Good:
        - (...)
        - (...)
        - (...)
        Bad:
        - (...)
        - (...)
        - (...)
        Action Suggestion:
        - (...)
        - (...)
        - (...)
        {diff}
        """)
    data = {"contents": [{"parts": [{"text": prompt}]}]}

    try:
        response = requests.post(LLM_API_URL, headers=headers, data=json.dumps(data))
        response.raise_for_status()
        # Safely extract the review text
        content = response.json()
        review_text = content.get("candidates", [{}])[0].get("content", {}).get("parts", [{}])[0].get("text")
        if not review_text:
            print("Error: Could not extract review from LLM API response.", file=sys.stderr)
            print(f"Full response: {content}", file=sys.stderr)
            sys.exit(1)
        return review_text
    except requests.exceptions.RequestException as e:
        print(f"Error calling LLM API: {e}", file=sys.stderr)
        sys.exit(1)
    except (KeyError, IndexError) as e:
        print(f"Error parsing LLM API response: {e}", file=sys.stderr)
        print(f"Full response: {response.text}", file=sys.stderr)
        sys.exit(1)


def post_review_comment(pr_number: str, review: str):
    """GitHub PR에 코드리뷰 댓글을 게시"""
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
    코드리뷰 프로세스 실행
    """
    llm_api_key = os.getenv("LLM_API_KEY")
    if not llm_api_key:
        print("Error: LLM_API_KEY environment variable not set.", file=sys.stderr)
        sys.exit(1)

    if len(sys.argv) < 2:
        print("Error: Pull request number not provided.", file=sys.stderr)
        print("Usage: python code_review.py <PR_NUMBER>", file=sys.stderr)
        sys.exit(1)

    pr_number = sys.argv[1]

    # 마지막 리뷰 이후 새로운 커밋이 있는지 확인
    if not has_new_commits_since_last_review(pr_number):
        print(f"No new commits found since last review for PR #{pr_number}. Skipping code review.")
        return

    print(f"Fetching diff for PR #{pr_number}...")
    diff_output = get_pr_diff(pr_number)

    # diff가 비어있는지 확인
    if not diff_output:
        print(f"No diff found for PR #{pr_number}. Skipping code review.")
        return

    print("Requesting review from LLLM...")
    review = get_review_from_llm(diff_output, llm_api_key)

    print(f"Posting review to PR #{pr_number}...")
    post_review_comment(pr_number, review)

    print("Code review comment posted successfully.")

if __name__ == "__main__":
    main()
