#!/usr/bin/python3

import subprocess
import os
import json

def check_cron_files_ownership_and_permissions():
    results = {
        "분류": "시스템 관리",
        "코드": "U-22",
        "위험도": "상",
        "진단 항목": "cron 파일 소유자 및 권한 설정",
        "진단 결과": "",
        "현황": [],
        "대응방안": "[양호]: cron 접근제어 파일 소유자가 root이고, 권한이 640 이하인 경우\n[취약]: cron 접근제어 파일 소유자가 root가 아니거나, 권한이 640 이하가 아닌 경우"
    }

    files = [
        "/etc/crontab", "/etc/cron.hourly", "/etc/cron.daily", 
        "/etc/cron.weekly", "/etc/cron.monthly", "/etc/cron.allow", 
        "/etc/cron.deny", "/var/spool/cron*", "/var/spool/cron/crontabs/"
    ]

    for file_path in files:
        for expanded_path in glob.glob(file_path):
            if os.path.exists(expanded_path):
                owner = subprocess.getoutput(f'stat -c %U "{expanded_path}"')
                perms = subprocess.getoutput(f'stat -c %a "{expanded_path}"')
                
                if owner != "root":
                    results["현황"].append(f"{expanded_path}은(는) root가 아닌 {owner}가 소유합니다.")
                else:
                    results["현황"].append(f"{expanded_path}은(는) root가 소유합니다.")
                
                if int(perms) > 640:
                    results["현황"].append(f"{expanded_path}에 {perms} 권한이 640보다 큽니다.")
                else:
                    results["현황"].append(f"{expanded_path}에 {perms} 권한이 640보다 작습니다.")
            else:
                results["현황"].append(f"{expanded_path}이(가) 존재하지 않습니다.")

    return results

def main():
    results = check_cron_files_ownership_and_permissions()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()

