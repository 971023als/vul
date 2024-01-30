#!/usr/bin/env python3
import json
import os
import stat

# 결과를 저장할 딕셔너리
results = {
    "U-11": {
        "title": "/etc/rsyslog.conf 파일 소유자 및 권한 설정",
        "status": "",
        "description": {
            "good": "/etc/rsyslog.conf 파일의 소유자가 root(또는 bin, sys)이고, 권한이 640 이하인 경우",
            "bad": "/etc/rsyslog.conf 파일의 소유자가 root(또는 bin, sys)가 아니거나, 권한이 640 이하가 아닌 경우"
        },
        "details": []
    }
}

def check_rsyslog_conf_ownership_and_permissions():
    rsyslog_conf_file = "/etc/rsyslog.conf"
    
    if os.path.exists(rsyslog_conf_file):
        file_stat = os.stat(rsyslog_conf_file)
        owner_uid = file_stat.st_uid
        permissions = stat.S_IMODE(file_stat.st_mode)
        owner = os.popen(f'stat -c "%U" {rsyslog_conf_file}').read().strip()

        if owner not in ["root", "bin", "sys"]:
            results["U-11"]["status"] = "취약"
            results["U-11"]["details"].append(f"{rsyslog_conf_file}가 {owner}에 의해 소유되어 있습니다.")
        else:
            if permissions <= 0o640:
                results["U-11"]["details"].append(f"{rsyslog_conf_file}에 대한 사용 권한이 {permissions}으로 안전합니다.")
                results["U-11"]["status"] = "양호"
            else:
                results["U-11"]["status"] = "취약"
                results["U-11"]["details"].append(f"{rsyslog_conf_file}에 대한 사용 권한이 {permissions}으로 안전하지 않습니다.")
    else:
        results["U-11"]["details"].append(f"{rsyslog_conf_file} 존재하지 않습니다.")
        results["U-11"]["status"] = "정보"

check_rsyslog_conf_ownership_and_permissions()

# 결과 파일에 JSON 형태로 저장
result_file = 'rsyslog_conf_ownership_and_permissions_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
