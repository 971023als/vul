#!/usr/bin/python3

import os
import json

def check_xinetd_conf_ownership_and_permissions():
    # Define the path to the /etc/xinetd.conf file
    xinetd_conf_file = "/etc/xinetd.conf"
    result = {
        "분류": "시스템 설정",
        "코드": "U-10",
        "위험도": "상",
        "진단 항목": "/etc/xinetd.conf 파일 소유자 및 권한 설정",
        "진단 결과": "",
        "현황": [],
        "대응방안": "/etc/xinetd.conf 파일의 소유자를 root로 설정하고, 권한을 600으로 설정하세요."
    }

    # Check if the /etc/xinetd.conf file exists
    if not os.path.exists(xinetd_conf_file):
        result["현황"].append(f"{xinetd_conf_file} 파일이 존재하지 않습니다.")
        result["진단 결과"] = "양호"
        return result

    # Check the ownership of the /etc/xinetd.conf file
    file_owner = os.stat(xinetd_conf_file).st_uid
    if file_owner != 0:  # UID 0 is root
        result["현황"].append(f"{xinetd_conf_file} 파일의 소유자가 root가 아닙니다.")
        result["진단 결과"] = "취약"
    else:
        result["현황"].append(f"{xinetd_conf_file} 파일의 소유자가 root입니다.")

    # Check the permissions of the /etc/xinetd.conf file
    file_permissions = os.stat(xinetd_conf_file).st_mode & 0o777
    if file_permissions > 0o600:
        result["현황"].append(f"{xinetd_conf_file} 파일의 권한이 600 초과입니다.")
        result["진단 결과"] = "취약"
    else:
        result["현황"].append(f"{xinetd_conf_file} 파일의 권한이 600 이하입니다.")

    return result

def main():
    result = check_xinetd_conf_ownership_and_permissions()
    print(json.dumps(result, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
