#!/usr/bin/python3
import os
import stat
import json

def check_etc_shadow_file_ownership_and_permissions():
    results = {
        "분류": "시스템 설정",
        "코드": "U-08",
        "위험도": "상",
        "진단 항목": "/etc/shadow 파일 소유자 및 권한 설정",
        "진단 결과": "",
        "현황": [],
        "대응방안": "[양호]: /etc/shadow 파일의 소유자가 root이고, 권한이 400인 경우\n[취약]: /etc/shadow 파일의 소유자가 root가 아니거나, 권한이 400이 아닌 경우"
    }

    shadow_file = "/etc/shadow"
    try:
        file_stat = os.stat(shadow_file)
        file_owner = stat.filemode(file_stat.st_mode)
        file_permissions = oct(file_stat.st_mode)[-3:]

        # Check if the file is owned by root
        if os.getuid() == file_stat.st_uid:
            results["현황"].append("/etc/shadow 파일이 루트에 의해 소유됩니다.")
        else:
            results["진단 결과"] = "취약"
            results["현황"].append("/etc/shadow 파일이 루트에 의해 소유되지 않습니다.")

        # Check if the file permissions are exactly 400
        if file_permissions == "0400":
            results["현황"].append("/etc/shadow 파일에 400의 권한이 있습니다.")
        else:
            results["진단 결과"] = "취약"
            results["현황"].append("/etc/shadow 파일에 400의 권한이 없습니다.")
    except FileNotFoundError:
        results["진단 결과"] = "취약"
        results["현황"].append(f"{shadow_file} 파일이 존재하지 않습니다.")

    return results

def main():
    results = check_etc_shadow_file_ownership_and_permissions()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
