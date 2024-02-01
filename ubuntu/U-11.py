#!/usr/bin/python3

import os
import stat
import json

def check_rsyslog_conf_ownership_and_permissions():
    rsyslog_conf_file = "/etc/rsyslog.conf"
    result = {
        "분류": "서비스 관리",
        "코드": "U-11",
        "위험도": "상",
        "진단 항목": "/etc/rsyslog.conf 파일 소유자 및 권한 설정",
        "진단 결과": "",
        "현황": [],
        "대응방안": "/etc/rsyslog.conf 파일의 소유자를 root(또는 bin, sys)로 설정하고, 권한을 640 이하로 설정하세요."
    }

    # Check if the /etc/rsyslog.conf file exists
    if not os.path.exists(rsyslog_conf_file):
        result["현황"].append(f"{rsyslog_conf_file} 파일이 존재하지 않습니다.")
        result["진단 결과"] = "정보 부족"
        return result

    # Check the ownership of the /etc/rsyslog.conf file
    file_stat = os.stat(rsyslog_conf_file)
    file_owner_uid = file_stat.st_uid
    file_perms = stat.S_IMODE(file_stat.st_mode)
    acceptable_owners = ["root", "bin", "sys"]
    owner_name = os.getpwuid(file_owner_uid).pw_name

    if owner_name not in acceptable_owners:
        result["현황"].append(f"{rsyslog_conf_file}의 소유자가 {owner_name}입니다.")
        result["진단 결과"] = "취약"
    else:
        result["현황"].append(f"{rsyslog_conf_file}의 소유자가 적절합니다.")

    # Check the permissions of the /etc/rsyslog.conf file
    if file_perms > 0o640:
        result["현황"].append(f"{rsyslog_conf_file}의 권한이 {oct(file_perms)}로 설정되어 있습니다.")
        result["진단 결과"] = "취약"
    else:
        result["현황"].append(f"{rsyslog_conf_file}의 권한이 적절합니다.")

    return result

def main():
    result = check_rsyslog_conf_ownership_and_permissions()
    print(json.dumps(result, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
