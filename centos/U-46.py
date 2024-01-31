#!/bin/python3

import re
import subprocess
import json

# 결과 저장을 위한 딕셔너리
results = {
    "분류": "서비스 관리",
    "코드": "U-46",
    "위험도": "상",
    "진단 항목": "패스워드 최소 길이 설정",
    "진단 결과": "",
    "현황": "",
    "대응방안": ""
}

# /etc/login.defs 파일 경로
login_defs_file = "/etc/login.defs"

# PASS_MIN_LEN 값 추출
try:
    with open(login_defs_file, 'r') as file:
        for line in file:
            if line.startswith("PASS_MIN_LEN"):
                pass_min_len = int(line.split()[1])
                break
        else:
            pass_min_len = None
except FileNotFoundError:
    pass_min_len = None

# 패스워드 최소 길이 점검
if pass_min_len is not None:
    if pass_min_len >= 8:
        results["진단 결과"] = "양호"
        results["현황"] = f"패스워드 최소 길이가 {pass_min_len}자로 설정되어 있습니다."
        results["대응방안"] = "현재 설정 유지"
    else:
        results["진단 결과"] = "취약"
        results["현황"] = f"패스워드 최소 길이가 {pass_min_len}자로 설정되어 있습니다. 8자 미만입니다."
        results["대응방안"] = "패스워드 최소 길이를 8자 이상으로 설정"
else:
    results["진단 결과"] = "정보 부족"
    results["현황"] = "/etc/login.defs 파일에서 PASS_MIN_LEN 설정을 찾을 수 없습니다."
    results["대응방안"] = "/etc/login.defs 파일 검토 및 PASS_MIN_LEN 설정 적용"

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
