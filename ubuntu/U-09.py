#!/usr/bin/python3

import os
import subprocess
import json

def check_etc_hosts_ownership_and_permissions():
    # Define the path to the /etc/hosts file
    hosts_file = "/etc/hosts"
    result = {
        "분류": "시스템 설정",
        "코드": "U-09",
        "위험도": "상",
        "진단 항목": "/etc/hosts 파일 소유자 및 권한 설정",
        "진단 결과": "",
        "현황": [],
        "대응방안": "/etc/hosts 파일의 소유자를 root로 설정하고, 권한을 600 이하로 설정하세요."
    }

    # Check if the /etc/hosts file exists
    if not os.path.exists(hosts_file):
        result["현황"].append(f"{hosts_file} 파일이 존재하지 않습니다.")
        result["진단 결과"] = "정보 부족"
        return result

    # Check the ownership of the /etc/hosts file
    owner = subprocess.getoutput(f'stat -c "%U" {hosts_file}')
    if owner != "root":
        result["현황"].append(f"{hosts_file} 파일의 소유자가 root가 아닙니다.")
        result["진단 결과"] = "취약"
    else:
        result["현황"].append(f"{hosts_file} 파일의 소유자가 root입니다.")

    # Check the permissions of the /etc/hosts file
    permissions = int(subprocess.getoutput(f'stat -c "%a" {hosts_file}'))
    if permissions > 600:
        result["현황"].append(f"{hosts_file} 파일의 권한이 600 이상입니다.")
        result["진단 결과"] = "취약"
    else:
        result["현황"].append(f"{hosts_file} 파일의 권한이 600 이하입니다.")

    if result["진단 결과"] != "취약":
        result["진단 결과"] = "양호"

    return result

def main():
    result = check_etc_hosts_ownership_and_permissions()
    print(json.dumps(result, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
