#!/usr/bin/python3

import os
import subprocess
import json

def check_shadow_file_ownership_and_permission():
    # Define the path to the shadow file
    shadow_file = '/etc/shadow'
    result = {
        "분류": "시스템 설정",
        "코드": "U-08",
        "위험도": "상",
        "진단 항목": "/etc/shadow 파일 소유자 및 권한 설정",
        "진단 결과": "",
        "현황": [],
        "대응방안": "/etc/shadow 파일의 소유자를 root로 설정하고, 권한을 400으로 설정하세요."
    }

    # Check if the shadow file exists
    if not os.path.exists(shadow_file):
        result["현황"].append(f"{shadow_file} 파일이 존재하지 않습니다.")
        result["진단 결과"] = "정보 부족"
        return result

    # Check ownership of the shadow file
    owner = subprocess.getoutput(f'stat -c "%U" {shadow_file}')
    if owner != "root":
        result["현황"].append(f"{shadow_file} 파일의 소유자가 root가 아닙니다.")
        result["진단 결과"] = "취약"
    else:
        result["현황"].append(f"{shadow_file} 파일의 소유자가 root입니다.")

    # Check permissions of the shadow file
    permissions = int(subprocess.getoutput(f'stat -c "%a" {shadow_file}'))
    if permissions != 400:
        result["현황"].append(f"{shadow_file} 파일의 권한이 400이 아닙니다.")
        result["진단 결과"] = "취약"
    else:
        result["현황"].append(f"{shadow_file} 파일의 권한이 400입니다.")

    if result["진단 결과"] != "취약":
        result["진단 결과"] = "양호"

    return result

def main():
    result = check_shadow_file_ownership_and_permission()
    print(json.dumps(result, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
