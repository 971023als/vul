#!/usr/bin/env python3
import json
import os
import stat

# 결과를 저장할 딕셔너리
results = {
    "U-09": {
        "title": "/etc/hosts 파일 소유자 및 권한 설정",
        "status": "",
        "description": {
            "good": "/etc/hosts 파일의 소유자가 root이고, 권한이 600 이하인 경우",
            "bad": "/etc/hosts 파일의 소유자가 root가 아니거나, 권한이 600 이상인 경우"
        },
        "details": []
    }
}

def check_hosts_file_ownership_and_permissions():
    hosts_file = "/etc/hosts"
    
    if os.path.exists(hosts_file):
        file_stat = os.stat(hosts_file)
        owner_uid = file_stat.st_uid
        permissions = stat.S_IMODE(file_stat.st_mode)
        
        # Check if the file is owned by root
        if owner_uid == 0:
            results["U-09"]["details"].append(f"{hosts_file}의 소유자는 루트입니다.")
        else:
            results["U-09"]["status"] = "취약"
            owner = os.popen(f'stat -c "%U" {hosts_file}').read().strip()
            results["U-09"]["details"].append(f"{hosts_file}의 소유자가 루트가 아니라 {owner}가 소유하고 있다.")
        
        # Check if the file permissions are 600 or less
        if permissions <= 0o600:
            results["U-09"]["details"].append(f"{hosts_file}의 권한은 최소 600 입니다.")
            if results["U-09"]["status"] != "취약":
                results["U-09"]["status"] = "양호"
        else:
            results["U-09"]["status"] = "취약"
            results["U-09"]["details"].append(f"{hosts_file}의 권한이 600 미만입니다. {permissions} 설정.")
    else:
        results["U-09"]["status"] = "정보"
        results["U-09"]["details"].append(f"{hosts_file} 파일이 존재하지 않습니다.")

check_hosts_file_ownership_and_permissions()

# 결과 파일에 JSON 형태로 저장
result_file = 'hosts_file_ownership_and_permissions_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
