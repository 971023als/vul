#!/usr/bin/python3
import os
import stat
import json

def check_etc_hosts_file_ownership_and_permissions():
    results = {
        "분류": "시스템 설정",
        "코드": "U-09",
        "위험도": "상",
        "진단 항목": "/etc/hosts 파일 소유자 및 권한 설정",
        "진단 결과": "",
        "현황": [],
        "대응방안": "[양호]: /etc/hosts 파일의 소유자가 root이고, 권한이 600 이하경우\n[취약]: /etc/hosts 파일의 소유자가 root가 아니거나, 권한이 600 이상인 경우"
    }

    hosts_file = "/etc/hosts"
    try:
        file_stat = os.stat(hosts_file)
        file_owner = stat.filemode(file_stat.st_mode)
        file_permissions = oct(file_stat.st_mode)[-3:]

        # Check if the file is owned by root
        if os.getuid() == file_stat.st_uid:
            results["진단 결과"] = "양호"
            results["현황"].append(f"{hosts_file}의 소유자는 루트입니다.")
        else:
            results["진단 결과"] = "취약"
            results["현황"].append(f"{hosts_file}의 소유자가 루트가 아니라 {file_owner}가 소유하고 있다.")

        # Check if the file permissions are 600 or less
        if int(file_permissions) <= 600:
            results["진단 결과"] = "양호"
            results["현황"].append(f"{hosts_file}의 권한은 최소 600 입니다.")
        else:
            results["진단 결과"] = "취약"
            results["현황"].append(f"{hosts_file}의 권한이 600 미만입니다. {file_permissions} 설정.")
    except FileNotFoundError:
        results["진단 결과"] = "정보부족"
        results["현황"].append(f"{hosts_file} 파일이 존재하지 않습니다.")

    return results

def main():
    results = check_etc_hosts_file_ownership_and_permissions()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
