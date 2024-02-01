#!/usr/bin/python3
import os
import stat
import json

def check_etc_services_file_ownership_and_permissions():
    results = {
        "분류": "시스템 설정",
        "코드": "U-12",
        "위험도": "상",
        "진단 항목": "/etc/services 파일 소유자 및 권한 설정",
        "진단 결과": "",
        "현황": [],
        "대응방안": "[양호]: /etc/services 파일의 소유자가 root이고, 권한이 644인 경우\n[취약]: /etc/services 파일의 소유자가 root가 아니거나, 권한이 644가 아닌 경우"
    }

    services_file = "/etc/services"
    if os.path.exists(services_file):
        file_stat = os.stat(services_file)
        file_owner = stat.filemode(file_stat.st_mode)
        file_permissions = oct(file_stat.st_mode)[-3:]

        # Check if the file is owned by root
        if os.getuid() == file_stat.st_uid:
            results["현황"].append(f"{services_file} 파일이 루트에 의해 소유됩니다.")
        else:
            results["진단 결과"] = "취약"
            results["현황"].append(f"{services_file} 파일이 루트에 의해 소유되지 않습니다.")

        # Check if the file permissions are exactly 644
        if int(file_permissions) == 644:
            results["현황"].append(f"{services_file} 파일은 루트(또는 bin, sys)에 의해 소유되며 644개 이하의 권한이 있습니다.")
        else:
            results["진단 결과"] = "취약"
            results["현황"].append(f"{services_file} 파일 사용 권한이 644보다 큽니다.")
    else:
        results["현황"].append("/etc/services 파일이 없습니다")

    return results

def main():
    results = check_etc_services_file_ownership_and_permissions()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
