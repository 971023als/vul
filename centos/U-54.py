#!/bin/python3

import re
import json

# /etc/profile 파일 경로
profile_file = "/etc/profile"

# 결과 저장을 위한 딕셔너리
results = {
    "분류": "서비스 관리",
    "코드": "U-54",
    "위험도": "상",
    "진단 항목": "Session Timeout 설정",
    "진단 결과": "",
    "현황": "",
    "대응방안": ""
}

try:
    with open(profile_file, 'r') as file:
        content = file.read()

    # TMOUT 설정값 검사
    match = re.search(r'^TMOUT=(\d+)', content, re.MULTILINE)
    if match:
        tmout_value = int(match.group(1))
        if tmout_value <= 600:
            results["진단 결과"] = "양호"
            results["현황"] = f"/etc/profile에서 TMOUT가 {tmout_value}초로 설정됨"
            results["대응방안"] = "현재 설정 유지"
        else:
            results["진단 결과"] = "취약"
            results["현황"] = f"/etc/profile에서 TMOUT가 {tmout_value}초로 설정됨, 600초 이하로 설정하는 것이 권장됩니다."
            results["대응방안"] = "/etc/profile에서 TMOUT 값을 600초 이하로 설정"
    else:
        results["진단 결과"] = "취약"
        results["현황"] = "/etc/profile에서 TMOUT 설정을 찾을 수 없습니다."
        results["대응방안"] = "/etc/profile에 TMOUT=600 설정을 추가"

except FileNotFoundError:
    results["진단 결과"] = "정보 부족"
    results["현황"] = f"{profile_file} 파일을 찾을 수 없습니다."
    results["대응방안"] = "/etc/profile 파일의 위치를 확인하고, 필요한 설정을 적용"

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
