#!/usr/bin/python3
import os
import stat
import json

def check_hosts_lpd_permissions():
    results = {
        "분류": "시스템 설정",
        "코드": "U-55",
        "위험도": "상",
        "진단 항목": "hosts.lpd 파일 소유자 및 권한 설정",
        "진단 결과": "",
        "현황": [],
        "대응방안": "[양호]: 파일의 소유자가 root이고 권한이 600이하 경우\n[취약]: 파일의 소유자가 root가 아니고 권한이 600 초과인 경우"
    }

    file_path = "/etc/hosts.lpd"
    if not os.path.exists(file_path):
        results["현황"].append("hosts.lpd 파일이 없습니다. 확인해주세요.")
    else:
        file_stat = os.stat(file_path)
        file_owner = file_stat.st_uid
        file_perms = stat.S_IMODE(file_stat.st_mode)
        
        if file_owner == 0:  # UID 0 is root
            results["현황"].append("hosts.lpd의 소유자는 루트입니다. 이것은 허용됩니다.")
        else:
            results["진단 결과"] = "취약"
            results["현황"].append("hosts.lpd의 소유자는 루트가 아닙니다. 이것은 허용되지 않습니다.")
        
        if file_perms > 0o600:
            results["진단 결과"] = "취약"
            results["현황"].append("hosts.lpd에 대한 권한이 600보다 큽니다.")
        else:
            if "취약" not in results["진단 결과"]:
                results["진단 결과"] = "양호"
            results["현황"].append("hosts.lpd에 대한 권한이 600이하 입니다.")

    return results

def main():
    results = check_hosts_lpd_permissions()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()