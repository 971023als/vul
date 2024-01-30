#!/usr/bin/env python3
import json
import os
import stat
import subprocess

# 결과를 저장할 딕셔너리
results = {
    "U-17": {
        "title": "$HOME/.rhosts, hosts.equiv 사용 금지",
        "status": "",
        "description": {
            "good": "login, shell, exec 서비스를 사용하지 않거나, 적절한 설정이 적용된 경우",
            "bad": "위와 같은 설정이 적용되지 않은 경우"
        },
        "details": []
    }
}

def check_file_ownership_permissions_content(file_path, expected_owner):
    if os.path.exists(file_path):
        file_stat = os.stat(file_path)
        owner = os.popen(f'stat -c "%U" {file_path}').read().strip()
        permissions = stat.S_IMODE(file_stat.st_mode)
        
        if owner != expected_owner:
            results["U-17"]["details"].append(f"{file_path} 은(는) {expected_owner}에 의해 소유되지 않음({owner} 가 소유함)")
        else:
            results["U-17"]["details"].append(f"{file_path} 은(는) {expected_owner}에 의해 소유됩니다.")
        
        if permissions > 0o600:
            results["U-17"]["details"].append(f"{file_path} 에 허용되지 않는 권한({permissions})이 있습니다.")
        else:
            results["U-17"]["details"].append(f"{file_path} 에 허용 가능한 권한({permissions})이 있습니다.")
        
        with open(file_path, 'r') as file:
            if '+' in file.read():
                results["U-17"]["details"].append(f"{file_path} '+' 설정이 있습니다")
            else:
                results["U-17"]["details"].append(f"{file_path} '+' 설정이 없습니다")
    else:
        results["U-17"]["details"].append(f"{file_path} 을(를) 찾을 수 없습니다")

check_file_ownership_permissions_content("/etc/hosts.equiv", "root")
check_file_ownership_permissions_content(os.path.expanduser("~/.rhosts"), os.getenv("USER"))

# 결과 분석
if any("+' 설정이 있습니다" in detail for detail in results["U-17"]["details"]):
    results["U-17"]["status"] = "취약"
else:
    results["U-17"]["status"] = "양호"

# 결과 파일에 JSON 형태로 저장
result_file = 'home_rhosts_hosts_equiv_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
