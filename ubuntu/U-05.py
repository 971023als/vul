#!/usr/bin/python3

import os
import json

# 결과 저장을 위한 딕셔너리
results = {
    "분류": "환경 설정",
    "코드": "U-05",
    "위험도": "상",
    "진단 항목": "root 홈, 패스 디렉토리 권한 및 패스 설정",
    "진단 결과": "",
    "현황": [],
    "대응방안": "PATH 환경변수에서 '.' 제거 권장."
}

# PATH 환경 변수에서 '.' 위치 확인
path_env = os.getenv("PATH").split(':')

if "." in path_env:
    results["진단 결과"] = "취약"
    results["현황"].append("PATH 환경변수에 '.' 포함됨.")
else:
    if any(part == "" for part in path_env):
        results["진단 결과"] = "취약"
        results["현황"].append("PATH 환경변수에 빈 항목('') 포함됨, 이는 현재 디렉토리('.')을 의미할 수 있음.")
    else:
        results["진단 결과"] = "양호"
        results["현황"].append("PATH 환경변수에 '.' 또는 빈 항목('') 포함되지 않음.")

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
