#!/usr/bin/python3
import os
import stat
import pwd
import json

def check_nfs_config_permissions():
    results = {
        "분류": "시스템 설정",
        "코드": "U-69",
        "위험도": "상",
        "진단 항목": "NFS 설정파일 접근권한",
        "진단 결과": "",
        "현황": [],
        "대응방안": "[양호]: NFS 접근제어 설정파일의 소유자가 root이고, 권한이 644 이하인 경우\n[취약]: NFS 접근제어 설정파일의 소유자가 root가 아니거나, 권한이 644 초과인 경우"
    }

    filename = "/etc/exports"
    if not os.path.exists(filename):
        results["현황"].append(f"{filename} 가 존재하지 않습니다.")
    else:
        file_stat = os.stat(filename)
        file_owner = pwd.getpwuid(file_stat.st_uid).pw_name
        file_permission = stat.S_IMODE(file_stat.st_mode)

        if file_owner != "root":
            results["진단 결과"] = "취약"
            results["현황"].append(f"{filename}의 소유자가 루트가 아닙니다.")
        else:
            results["현황"].append(f"{filename}의 소유자가 루트가 맞습니다.")

        if file_permission > 0o644:
            results["진단 결과"] = "취약"
            results["현황"].append(f"{filename}의 권한이 644보다 큽니다.")
        else:
            if "취약" not in results["진단 결과"]:
                results["진단 결과"] = "양호"
            results["현황"].append(f"{filename}의 권한이 644 이하입니다.")

    return results

def main():
    results = check_nfs_config_permissions()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
