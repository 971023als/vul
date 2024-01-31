#!/usr/bin/python3

import os
import subprocess
import json

def check_passwd_file_ownership_and_permission():
    # Initialize result dictionary
    result = {
        "분류": "시스템 설정",
        "코드": "U-07",
        "위험도": "상",
        "진단 항목": "/etc/passwd 파일 소유자 및 권한 설정",
        "진단 결과": "",
        "현황": [],
        "대응방안": "/etc/passwd 파일의 소유자를 root로 설정하고, 권한을 644 이하로 설정하세요."
    }

    passwd_file = '/etc/passwd'
    # Check if /etc/passwd exists
    if not os.path.exists(passwd_file):
        result["진단 결과"] = "정보 부족"
        result["현황"].append(f"{passwd_file} 파일이 존재하지 않습니다.")
        return result

    # Check ownership of /etc/passwd
    owner = subprocess.getoutput(f'stat -c "%U" {passwd_file}')
    if owner != "root":
        result["진단 결과"] = "취약"
        result["현황"].append(f"{passwd_file} 파일의 소유자가 root가 아닙니다.")
    else:
        result["현황"].append(f"{passwd_file} 파일의 소유자가 root입니다.")

    # Check permissions of /etc/passwd
    permissions = int(subprocess.getoutput(f'stat -c "%a" {passwd_file}'))
    if permissions > 644:
        result["진단 결과"] = "취약"
        result["현황"].append(f"{passwd_file} 파일의 권한이 644 이하가 아닙니다.")
    else:
        result["현황"].append(f"{passwd_file} 파일의 권한이 644 이하입니다.")

    if result["진단 결과"] != "취약":
        result["진단 결과"] = "양호"

    return result

def main():
    result = check_passwd_file_ownership_and_permission()
    print(json.dumps(result, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
