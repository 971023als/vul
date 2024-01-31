#!/usr/bin/python3

import subprocess
import json

# 결과 저장을 위한 딕셔너리
results = {
    "분류": "계정 관리",
    "코드": "U-03",
    "위험도": "상",
    "진단 항목": "계정 잠금 임계값 설정",
    "진단 결과": "",
    "현황": "",
    "대응방안": ""
}

# /etc/pam.d/common-auth 파일에서 pam_tally2.so 설정 검사
try:
    with open('/etc/pam.d/common-auth', 'r') as file:
        pam_configs = file.readlines()

    # pam_tally2.so 설정이 적절한지 확인합니다.
    correct_setting = "auth required pam_tally2.so deny=10 unlock_time=900"
    setting_found = any(correct_setting in line for line in pam_configs)
    
    if setting_found:
        results["진단 결과"] = "양호"
        results["현황"] = "계정 잠금 임계값이 10회 이하의 값으로 적절히 설정되어 있습니다."
        results["대응방안"] = "현재 설정을 유지하세요."
    else:
        results["진단 결과"] = "취약"
        results["현황"] = "계정 잠금 임계값이 설정되어 있지 않거나, 10회 이하의 값으로 설정되지 않았습니다."
        results["대응방안"] = "/etc/pam.d/common-auth 파일에서 'auth required pam_tally2.so deny=10 unlock_time=900' 설정을 확인하고 추가하세요."

except FileNotFoundError:
    results["진단 결과"] = "정보 부족"
    results["현황"] = "/etc/pam.d/common-auth 파일이 없습니다. PAM 설정 파일을 확인해주세요."
    results["대응방안"] = "PAM 설정 파일을 확인하고 필요한 설정을 추가하세요."

# 결과를 JSON 형태로 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
