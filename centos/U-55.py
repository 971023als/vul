#!/usr/bin/env python3
import json
import os
import stat

# 결과를 저장할 딕셔너리
results = {
    "U-55": {
        "title": "hosts.lpd 파일 소유자 및 권한 설정",
        "status": "",
        "description": {
            "good": "파일의 소유자가 root이고 권한이 600이하인 경우",
            "bad": "파일의 소유자가 root가 아니고 권한이 600 초과인 경우"
        },
        "details": []
    }
}

def check_hosts_lpd():
    file_path = '/etc/hosts.lpd'
    if not os.path.isfile(file_path):
        results["U-55"]["status"] = "정보"
        results["U-55"]["details"].append(f"{file_path} 파일이 없습니다.")
    else:
        file_stat = os.stat(file_path)
        owner = file_stat.st_uid
        permissions = stat.S_IMODE(file_stat.st_mode)
        
        if owner == 0 and permissions <= 0o600:
            results["U-55"]["status"] = "양호"
            results["U-55"]["details"].append(f"{file_path}의 소유자는 root이며, 권한이 600이하입니다.")
        else:
            results["U-55"]["status"] = "취약"
            if owner != 0:
                results["U-55"]["details"].append(f"{file_path}의 소유자가 root가 아닙니다.")
            if permissions > 0o600:
                results["U-55"]["details"].append(f"{file_path}의 권한이 600을 초과합니다.")

check_hosts_lpd()

# 결과 파일에 JSON 형태로 저장
result_file = 'hosts_lpd_owner_permission_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
