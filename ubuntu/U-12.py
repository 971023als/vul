#!/usr/bin/python3

import os
import stat
import json

def check_services_file_ownership_and_permissions():
    services_file = "/etc/services"
    result = {
        "분류": "서비스 관리",
        "코드": "U-12",
        "위험도": "상",
        "진단 항목": "/etc/services 파일 소유자 및 권한 설정",
        "진단 결과": "",
        "현황": [],
        "대응방안": "/etc/services 파일의 소유자를 root으로 설정하고, 권한을 644 이하로 설정하세요."
    }

    # Check if the /etc/services file exists
    if not os.path.exists(services_file):
        result["현황"].append(f"{services_file} 파일이 존재하지 않습니다.")
        result["진단 결과"] = "정보 부족"
        return result

    # Check the ownership of the /etc/services file
    file_stat = os.stat(services_file)
    file_owner_uid = file_stat.st_uid
    file_perms = stat.S_IMODE(file_stat.st_mode)
    owner_name = os.getpwuid(file_owner_uid).pw_name

    if owner_name != "root":
        result["현황"].append(f"{services_file}의 소유자가 {owner_name}입니다.")
        result["진단 결과"] = "취약"
    else:
        result["현황"].append(f"{services_file}의 소유자가 적절합니다.")

    # Check the permissions of the /etc/services file
    if file_perms > 0o644:
        result["현황"].append(f"{services_file}의 권한이 {oct(file_perms)}로 설정되어 있습니다.")
        result["진단 결과"] = "취약"
    else:
        result["현황"].append(f"{services_file}의 권한이 적절합니다.")

    return result

def main():
    result = check_services_file_ownership_and_permissions()
    print(json.dumps(result, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
