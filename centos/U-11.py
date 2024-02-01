#!/usr/bin/python3
import os
import stat
import json

def check_rsyslog_conf_file_ownership_and_permissions():
    results = {
        "분류": "시스템 설정",
        "코드": "U-11",
        "위험도": "상",
        "진단 항목": "/etc/rsyslog.conf 파일 소유자 및 권한 설정",
        "진단 결과": "",
        "현황": [],
        "대응방안": "[양호]: /etc/rsyslog.conf 파일의 소유자가 root(또는 bin, sys)이고, 권한이 640 이하인 경우\n[취약]: /etc/rsyslog.conf 파일의 소유자가 root(또는 bin, sys)가 아니거나, 권한이 640 이하가 아닌 경우"
    }

    rsyslog_conf_file = "/etc/rsyslog.conf"
    if os.path.exists(rsyslog_conf_file):
        file_stat = os.stat(rsyslog_conf_file)
        file_owner = stat.filemode(file_stat.st_mode)
        file_permissions = oct(file_stat.st_mode)[-3:]

        allowed_owners = ['root', 'bin', 'sys']
        if os.getuid() == file_stat.st_uid or file_owner in allowed_owners:
            results["현황"].append(f"{rsyslog_conf_file}가 {file_owner}에 의해 소유됩니다.")
        else:
            results["진단 결과"] = "취약"
            results["현황"].append(f"{rsyslog_conf_file}가 {file_owner}(또는 bin, sys)에 의해 소유되지 않습니다.")

        if int(file_permissions) <= 640:
            results["현황"].append(f"{rsyslog_conf_file}에 대한 사용 권한은 안전합니다")
        else:
            results["진단 결과"] = "취약"
            results["현황"].append(f"{rsyslog_conf_file}에 대한 사용 권한은 안전하지 않습니다")
    else:
        results["현황"].append(f"{rsyslog_conf_file} 존재하지 않음")

    return results

def main():
    results = check_rsyslog_conf_file_ownership_and_permissions()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
