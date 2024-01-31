#!/bin/python3

import json
import subprocess

# 결과를 저장할 리스트 초기화
results = []

# Anonymous FTP 활성화 여부 검사 함수
def check_anonymous_ftp():
    try:
        # /etc/passwd 파일에서 ftp 계정 검색
        process = subprocess.run(["grep", "ftp", "/etc/passwd"], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        if process.returncode == 0:
            return "취약", "Anonymous FTP가 활성화 되어 있는 경우"
        else:
            return "양호", "Anonymous FTP가 비활성화 되어 있는 경우"
    except Exception as e:
        return "오류", str(e)

# Anonymous FTP 검사 실행
diagnosis_result, status_message = check_anonymous_ftp()

# 결과 추가
results.append({
    "분류": "서비스 관리",
    "코드": "U-20",
    "위험도": "상",
    "진단 항목": "Anonymous FTP 비활성화",
    "진단 결과": diagnosis_result,
    "현황": status_message,
    "대응방안": "Anonymous FTP 비활성화"
})

# JSON 형태로 결과 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
