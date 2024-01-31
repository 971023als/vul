#!/bin/python3

import re
import json

# /etc/login.defs 파일 경로
login_defs_file = "/etc/login.defs"

# 결과 저장을 위한 딕셔너리
results = {
    "분류": "서비스 관리",
    "코드": "U-47",
    "위험도": "상",
    "진단 항목": "패스워드 최대 사용기간 설정",
    "진단 결과": "",
    "현황": "",
    "대응방안": ""
}

try:
    with open(login_defs_file, 'r') as file:
        content = file.read()

    # PASS_MAX_DAYS 값 추출
    match = re.search(r'^PASS_MAX_DAYS\s+(\d+)', content, re.MULTILINE)
    if match:
        pass_max_days = int(match.group(1))
        if pass_max_days <= 90:
            results["진단 결과"] = "양호"
            results["현황"] = f"패스워드 최대 사용기간이 {pass_max_days}일로 설정되어 있습니다."
            results["대응방안"] = "현재 설정 유지"
        else:
            results["진단 결과"] = "취약"
            results["현황"] = f"패스워드 최대 사용기간이 {pass_max_days}일로 설정되어 있습니다. 90일 이하로 설정하는 것이 권장됩니다."
            results["대응방안"] = "패스워드 최대 사용기간을 90일 이하로 설정"
    else:
        results["진단 결과"] = "취약"
        results["현황"] = "PASS_MAX_DAYS 설정이 /etc/login.defs 파일에 존재하지 않습니다."
        results["대응방안"] = "/etc/login.defs 파일에 PASS_MAX_DAYS 설정을 추가하고, 90일 이하로 설정"

except FileNotFoundError:
    results["진단 결과"] = "정보 부족"
    results["현황"] = f"{login_defs_file} 파일을 찾을 수 없습니다."
    results["대응방안"] = "/etc/login.defs 파일의 위치를 확인하고, 필요한 설정을 적용"

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
