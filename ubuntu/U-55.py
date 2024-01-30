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
            "good": "파일의 소유자가 root이고 권한이 600이하 경우",
            "bad": "파일의 소유자가 root가 아니고 권한이 600 초과인 경우"
        },
        "details": []
    }
}

def check_hosts_lpd():
    file_path = '/etc/hosts.lpd'
    if not os.path.exists(file_path):
        results["U-55"]["status"] = "정보"
        results["U-55"]["details"].append("hosts.lpd 파일이 없습니다. 확인해주세요.")
        return
    
    # 파일 소유자 확인
    file_stat = os.stat(file_path)
    uid = file_stat.st_uid
    mode = file_stat.st_mode
    file_owner = "root" if uid == 0 else "not root"
    file_permission = stat.S_IMODE(mode)

    if file_owner == "root":
        results["U-55"]["details"].append("hosts.lpd의 소유자는 루트입니다. 이것은 허용됩니다.")
    else:
        results["U-55"]["status"] = "취약"
        results["U-55"]["details"].append("hosts.lpd의 소유자는 루트가 아닙니다. 이것은 허용되지 않습니다.")

    # 파일 권한 확인
    if file_permission > 600:
        results["U-55"]["status"] = "취약"
        results["U-55"]["details"].append("hosts.lpd에 대한 권한이 600보다 큽니다.")
    else:
        results["U-55"]["details"].append("hosts.lpd에 대한 권한이 600이하 입니다.")
        if results["U-55"]["status"] != "취약":
            results["U-55"]["status"] = "양호"

check_hosts_lpd()

# 결과 파일에 JSON 형태로 저장
result_file = 'hosts_lpd_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
