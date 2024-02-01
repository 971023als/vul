#!/usr/bin/python3
import os
import stat
import json

def check_etc_passwd_file_ownership_and_permissions():
    results = {
        "분류": "시스템 설정",
        "코드": "U-07",
        "위험도": "상",
        "진단 항목": "/etc/passwd 파일 소유자 및 권한 설정",
        "진단 결과": "",
        "현황": [],
        "대응방안": "[양호]: /etc/passwd 파일의 소유자가 root이고, 권한이 644 이하인 경우\n[취약]: /etc/passwd 파일의 소유자가 root가 아니거나, 권한이 644 이하가 아닌 경우"
    }

    passwd_file = "/etc/passwd"
    try:
        file_stat = os.stat(passwd_file)
        file_owner = stat.filemode(file_stat.st_mode)
        file_permissions = oct(file_stat.st_mode)[-3:]

        # Check if the file is owned by root
        if os.getuid() == file_stat.st_uid:
            results["현황"].append("/etc/passwd 파일이 루트에 의해 소유됩니다.")
        else:
            results["진단 결과"] = "취약"
            results["현황"].append("/etc/passwd 파일이 루트에 의해 소유되지 않습니다.")

        # Check if the file permissions are 644 or less
        if int(file_permissions) <= 644:
            results["현황"].append("/etc/passwd 파일에 644 이하의 권한이 있습니다.")
        else:
            results["진단 결과"] = "취약"
            results["현황"].append("/etc/passwd 파일에 644 이하의 권한이 없습니다.")
    except FileNotFoundError:
        results["진단 결과"] = "취약"
        results["현황"].append(f"{passwd_file} 파일이 존재하지 않습니다.")

    return results

def main():
    results = check_etc_passwd_file_ownership_and_permissions()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
