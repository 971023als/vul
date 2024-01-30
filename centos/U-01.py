#!/usr/bin/env python3
import json
import re

# 결과를 저장할 딕셔너리
results = {
    "U-01": {
        "title": "root 계정 원격 접속 제한",
        "status": "",
        "description": {
            "good": "원격 서비스를 사용하지 않거나 사용시 직접 접속을 차단한 경우",
            "bad": "root 직접 접속을 허용하고 원격 서비스를 사용하는 경우"
        },
        "details": []
    }
}

def check_root_remote_access():
    ssh_config_file = "/etc/ssh/sshd_config"
    
    try:
        with open(ssh_config_file, 'r') as file:
            ssh_config_content = file.read()
        
        # Check for PermitRootLogin setting
        permit_root_login = re.search(r'^PermitRootLogin\s+yes', ssh_config_content, re.MULTILINE)
        
        if permit_root_login:
            results["U-01"]["status"] = "취약"
            results["U-01"]["details"].append("원격 터미널 서비스를 통해 루트 직접 액세스가 허용됨")
        else:
            results["U-01"]["status"] = "양호"
            results["U-01"]["details"].append("원격 터미널 서비스를 통해 루트 직접 액세스가 허용되지 않음")
    except FileNotFoundError:
        results["U-01"]["details"].append(f"{ssh_config_file} 파일이 존재하지 않습니다.")
        results["U-01"]["status"] = "정보"

check_root_remote_access()

# 결과 파일에 JSON 형태로 저장
result_file = 'root_remote_access_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
