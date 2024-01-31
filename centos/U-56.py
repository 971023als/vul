#!/bin/python3

import re
import json

# /etc/profile 파일 경로
profile_file = "/etc/profile"

# 결과 저장을 위한 딕셔너리
results = {
    "분류": "서비스 관리",
    "코드": "U-56",
    "위험도": "상",
    "진단 항목": "UMASK 설정 관리",
    "진단 결과": "",
    "현황": "",
    "대응방안": ""
}

try:
    with open(profile_file, 'r') as file:
        content = file.read()

    # umask 022 설정 검사
    umask_022_set = bool(re.search(r'\bumask\s+022\b', content))
    export_umask_set = bool(re.search(r'\bexport\s+umask\b', content))

    if umask_022_set:
        results["진단 결과"] = "양호"
        results["현황"] = "/etc/profile에서 umask가 022로 설정됨"
    else:
        results["진단 결과"] = "취약"
        results["현황"] = "/etc/profile에서 umask가 022로 설정되지 않음"

    if export_umask_set:
        results["대응방안"] += "/etc/profile에서 export umask로 설정됨. "
    else:
        results["대응방안"] += "/etc/profile에서 export umask로 설정되지 않음. "

    results["대응방안"] += "umask 값을 022 이하로 설정하십시오."

except FileNotFoundError:
    results = {
        "분류": "서비스 관리",
        "코드": "U-56",
        "위험도": "정보 부족",
        "진단 항목": "UMASK 설정 관리",
        "진단 결과": "정보 부족",
        "현황": f"{profile_file} 파일을 찾을 수 없습니다.",
        "대응방안": "/etc/profile 파일의 위치를 확인하고, 필요한 설정을 적용"
    }

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
