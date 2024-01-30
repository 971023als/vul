#!/usr/bin/env python3
import json
import os
import stat

# 결과를 저장할 딕셔너리
results = {
    "U-22": {
        "title": "cron 파일 소유자 및 권한 설정",
        "status": "",
        "description": {
            "good": "cron 접근제어 파일 소유자가 root이고, 권한이 640 이하인 경우",
            "bad": "cron 접근제어 파일 소유자가 root가 아니거나, 권한이 640 이하가 아닌 경우"
        },
        "details": []
    }
}

# 검사할 파일 목록
files = [
    "/etc/crontab", "/etc/cron.hourly", "/etc/cron.daily", "/etc/cron.weekly", 
    "/etc/cron.monthly", "/etc/cron.allow", "/etc/cron.deny", "/var/spool/cron", 
    "/var/spool/cron/crontabs"
]

def check_cron_files():
    for file in files:
        if os.path.exists(file):
            owner = os.popen(f'stat -c "%U" {file}').read().strip()
            permissions = stat.S_IMODE(os.stat(file).st_mode)
            
            if owner != "root":
                results["U-22"]["details"].append(f"{file} 은(는) root가 아닌 {owner}가 소유합니다.")
                results["U-22"]["status"] = "취약"
            if permissions > 0o640:
                results["U-22"]["details"].append(f"{file} 에 부여된 권한({permissions})이 640보다 큽니다.")
                results["U-22"]["status"] = "취약"
        else:
            results["U-22"]["details"].append(f"{file} 이(가) 존재하지 않습니다.")

check_cron_files()

# 결과가 "양호"로 설정되지 않은 경우를 확인
if "취약" not in results["U-22"]["status"]:
    results["U-22"]["status"] = "양호"

# 결과 파일에 JSON 형태로 저장
result_file = 'cron_files_ownership_and_permissions_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
