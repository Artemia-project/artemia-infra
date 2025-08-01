import os
import requests
import subprocess
import sys
import json

GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")
PR_NUMBER = sys.argv[1]

# 1. git diff 추출
diff_output = subprocess.check_output([
    "gh", "pr", "diff", PR_NUMBER
]).decode("utf-8")

# 2. Gemini API에 요청
def get_review_from_gemini(diff):
    url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent"
    headers = {
        "Content-Type": "application/json",
        "x-goog-api-key": GEMINI_API_KEY,
    }
    prompt = f"""You're a senior software engineer doing code review.
            Here is a diff from a pull request:
            {diff}

            Please provide a concise and constructive code review.
            """
    data = {
        "contents": [
            {"parts": [{"text": prompt}]}
        ]
    }

    res = requests.post(url, headers=headers, data=json.dumps(data))
    res.raise_for_status()
    return res.json()["candidates"][0]["content"]["parts"][0]["text"]

review = get_review_from_gemini(diff_output)

# 3. PR에 코멘트 작성
comment_cmd = [
    "gh", "pr", "comment", PR_NUMBER,
    "--body", review
]
subprocess.run(comment_cmd)
