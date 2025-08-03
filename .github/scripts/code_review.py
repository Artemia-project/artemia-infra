import os
import requests
import subprocess
import sys
import json
import textwrap
from datetime import datetime
from error_handler import error, warn, info, handle_subprocess_error, handle_api_error, safe_exit, ErrorContext

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
        warn("Could not get last review comment time", pr_number=pr_number)
        return ""

def get_new_commits_since_last_review(pr_number: str) -> list:
    """마지막 리뷰 이후 새로운 커밋들의 해시를 가져옴"""
    last_review_time = get_last_review_comment_time(pr_number)
    
    try:
        # 모든 커밋의 데이터를 가져와서 Python에서 날짜 비교
        commits_output = subprocess.check_output([
            "gh", "pr", "view", pr_number, "--json", "commits",
            "--jq", ".commits[] | {oid: .oid, committedDate: .committedDate}"
        ], text=True, stderr=subprocess.PIPE)
        
        if not commits_output.strip():
            return []
            
        new_commit_hashes = []
        
        # 이전 리뷰가 없으면 모든 커밋 반환
        if not last_review_time:
            for line in commits_output.strip().split('\n'):
                if line:
                    commit_data = json.loads(line)
                    new_commit_hashes.append(commit_data['oid'])
            return new_commit_hashes
        
        # 마지막 리뷰 이후 커밋들만 필터링
        last_review_dt = datetime.fromisoformat(last_review_time.replace('Z', '+00:00'))
        
        for line in commits_output.strip().split('\n'):
            if line:
                commit_data = json.loads(line)
                commit_dt = datetime.fromisoformat(commit_data['committedDate'].replace('Z', '+00:00'))
                if commit_dt > last_review_dt:
                    new_commit_hashes.append(commit_data['oid'])
        
        return new_commit_hashes
        
    except (subprocess.CalledProcessError, ValueError, json.JSONDecodeError):
        handle_subprocess_error(Exception(), "get new commits since last review", {"pr_number": pr_number})
        return []

def get_pr_diff(pr_number: str) -> str:
    """마지막 리뷰 이후 새로운 커밋들의 diff만 가져옴"""
    new_commits = get_new_commits_since_last_review(pr_number)
    
    if not new_commits:
        info(f"No new commits found for PR #{pr_number}")
        return ""
    
    try:
        if len(new_commits) == 1:
            # 단일 커밋의 경우 해당 커밋의 diff만
            diff_output = subprocess.check_output([
                "git", "show", "--format=", new_commits[0]
            ], text=True, stderr=subprocess.PIPE)
        else:
            # 여러 커밋의 경우 첫 커밋 이전부터 마지막 커밋까지의 range diff
            first_commit = new_commits[0]
            last_commit = new_commits[-1]
            
            # 첫 번째 커밋의 부모 찾기
            parent_output = subprocess.check_output([
                "git", "rev-parse", f"{first_commit}^"
            ], text=True, stderr=subprocess.PIPE)
            parent_commit = parent_output.strip()
            
            # 범위 diff 가져오기
            diff_output = subprocess.check_output([
                "git", "diff", f"{parent_commit}..{last_commit}"
            ], text=True, stderr=subprocess.PIPE)
        
        return diff_output.strip()
        
    except subprocess.CalledProcessError:
        # git 명령 실패 시 전체 PR diff로 폴백
        try:
            diff_output = subprocess.check_output(
                ["gh", "pr", "diff", pr_number], text=True, stderr=subprocess.PIPE
            )
            return diff_output.strip()
        except subprocess.CalledProcessError as e:
            handle_subprocess_error(e, "gh pr diff fallback", {"pr_number": pr_number})
            safe_exit(1, "Failed to fetch any diff")

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
            error("Could not extract review from LLM API response", full_response=str(content))
            safe_exit(1, "LLM API response parsing failed")
        return review_text
    except requests.exceptions.RequestException as e:
        handle_api_error(e, LLM_API_URL)
        safe_exit(1, "LLM API request failed")
    except (KeyError, IndexError) as e:
        error("Error parsing LLM API response", e, response_text=response.text)
        safe_exit(1, "LLM API response parsing failed")


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
        handle_subprocess_error(e, "gh pr comment", {"pr_number": pr_number})
        safe_exit(1, "Failed to post comment to PR")

def main():
    """
    코드리뷰 프로세스 실행
    """
    llm_api_key = os.getenv("LLM_API_KEY")
    if not llm_api_key:
        error("LLM_API_KEY environment variable not set")
        safe_exit(1, "Missing required environment variable")

    if len(sys.argv) < 2:
        error("Pull request number not provided")
        info("Usage: python code_review.py <PR_NUMBER>")
        safe_exit(1, "Invalid command line arguments")

    pr_number = sys.argv[1]

    # 전체 코드리뷰 프로세스를 컨텍스트로 관리
    with ErrorContext("code review process", pr_number=pr_number):
        info(f"Fetching new commits diff for PR #{pr_number}")
        diff_output = get_pr_diff(pr_number)

        # diff가 비어있는지 확인
        if not diff_output:
            info(f"No new commits to review for PR #{pr_number}. Skipping code review.")
            return

        info("Requesting review from LLM")
        review = get_review_from_llm(diff_output, llm_api_key)

        info(f"Posting review to PR #{pr_number}")
        post_review_comment(pr_number, review)

        info("Code review comment posted successfully")

if __name__ == "__main__":
    main()