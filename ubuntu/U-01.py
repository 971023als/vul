#!/bin/python3

import subprocess
import json

# 결과 저장을 위한 딕셔너리
results = {
    "분류": "서비스 관리",
    "코드": "U-01",
    "위험도": "상",
    "진단 항목": "root 계정 원격 접속 제한",
    "현황": "",
    "대응방안": ""
}

# SSH 구성 파일에서 PermitRootLogin 옵션 검사
try:
    with open('/etc/ssh/sshd_config', 'r') as file:
        sshd_config = file.readlines()
    
    root_login_permitted = any("PermitRootLogin yes" in line for line in sshd_config)
    
    if root_login_permitted:
        results["현황"] = "원격 터미널 서비스를 통해 루트 직접 액세스가 허용됨"
        results["진단 결과"] = "취약"
        results["대응방안"] = "/etc/ssh/sshd_config에서 PermitRootLogin을 'no'로 설정 권장"
    else:
        results["현황"] = "원격 터미널 서비스를 통해 루트 직접 액세스가 허용되지 않음"
        results["진단 결과"] = "양호"
        results["대응방안"] = "현재 설정 유지"

except FileNotFoundError:
    results["현황"] = "/etc/ssh/sshd_config 파일이 없습니다. SSH 서비스 설정을 확인해주세요."
    results["진단 결과"] = "정보 부족"
    results["대응방안"] = "SSH 서비스 설정 확인 및 적절한 설정 적용"

# 결과를 JSON 파일로 저장
with open('root_remote_access_check_result.json', 'w') as json_file:
    json.dump(results, json_file, ensure_ascii=False, indent=4)

print("root 계정 원격 접속 제한 설정 점검 결과가 root_remote_access_check_result.json 파일에 저장되었습니다.")
