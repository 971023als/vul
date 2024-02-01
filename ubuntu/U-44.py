#!/bin/python3

import subprocess
import json

# 결과 저장을 위한 리스트
results = []

# /etc/passwd 파일 경로
passwd_file = "/etc/passwd"

def check_duplicate_root_uid(passwd_path):
    """
    /etc/passwd 파일에서 root 계정과 동일한 UID(0)를 갖는 계정이 있는지 확인합니다.
    """
    with open(passwd_path, 'r') as file:
        root_uid_accounts = [line.split(':')[0] for line in file if line.split(':')[2] == "0"]
    
    if len(root_uid_accounts) > 1:
        return True, root_uid_accounts
    else:
        return False, root_uid_accounts

# 루트 계정과 동일한 UID를 가진 계정 확인
duplicate_root_uid, accounts = check_duplicate_root_uid(passwd_file)

diagnostic_item = "root 이외의 UID가 '0' 금지"
if duplicate_root_uid:
    status = "취약"
    situation = f"루트 계정과 동일한 UID를 가진 계정이 있습니다: {', '.join(accounts)}"
    countermeasure = "루트 계정과 동일한 UID를 가진 추가 계정 제거"
else:
    status = "양호"
    situation = "루트 계정과 동일한 UID를 가진 계정이 없습니다."
    countermeasure = "현재 상태 유지"

results_summary = {
    "분류": "서비스 관리",
    "코드": "U-44",
    "위험도": "상",
    "진단 항목": diagnostic_item,
    "진단 결과": status,
    "현황": situation,
    "대응방안": countermeasure
}

# 결과 출력
print(json.dumps(results_summary, ensure_ascii=False, indent=4))
