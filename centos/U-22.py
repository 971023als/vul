#!/usr/bin/python3
import os
import stat
import json

def check_cron_files_ownership_and_permissions():
    results = {
        "분류": "시스템 설정",
        "코드": "U-22",
        "위험도": "상",
        "진단 항목": "cron 파일 소유자 및 권한 설정",
        "진단 결과": "",
        "현황": [],
        "대응방안": "[양호]: cron 접근제어 파일 소유자가 root이고, 권한이 640 이하인 경우\n[취약]: cron 접근제어 파일 소유자가 root가 아니거나, 권한이 640 이하가 아닌 경우"
    }

    cron_files = [
        "/etc/crontab", "/etc/cron.hourly", "/etc/cron.daily",
        "/etc/cron.weekly", "/etc/cron.monthly", "/etc/cron.allow",
        "/etc/cron.deny", "/var/spool/cron", "/var/spool/cron/crontabs"
    ]

    for cron_file in cron_files:
        if os.path.exists(cron_file):
            file_stat = os.stat(cron_file)
            owner = stat.filemode(file_stat.st_mode)
            permissions = oct(file_stat.st_mode)[-3:]

            if os.getuid() != file_stat.st_uid or int(permissions) > 640:
                results["진단 결과"] = "취약"
                results["현황"].append(f"{cron_file} 소유자 또는 권한 설정이 적절하지 않습니다. (소유자: {owner}, 권한: {permissions})")
            else:
                results["현황"].append(f"{cron_file}은(는) 적절히 설정되었습니다. (소유자: root, 권한: {permissions} 이하)")
        else:
            results["현황"].append(f"{cron_file} 파일이 존재하지 않습니다.")

    if "진단 결과" not in results:
        results["진단 결과"] = "양호"

    return results

def main():
    results = check_cron_files_ownership_and_permissions()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
