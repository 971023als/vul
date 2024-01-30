#!/usr/bin/python3

import subprocess
import json

# 결과를 저장할 딕셔너리
results = {
    "U-01": {
        "title": "root 계정 원격 접속 제한",
        "status": "",
        "description": {
            "good": "원격 서비스를 사용하지 않거나 사용시 직접 접속을 차단한 경우",
            "bad": "root 직접 접속을 허용하고 원격 서비스를 사용하는 경우"
        },
        "message": ""
    }
}

# SSH 구성 파일에서 PermitRootLogin 옵션이 yes로 설정되어 있는지 확인
def check_permit_root_login():
    try:
        with open('/etc/ssh/sshd_config') as f:
            for line in f:
                if line.strip().startswith("PermitRootLogin yes"):
                    results["U-01"]["status"] = "취약"
                    results["U-01"]["message"] = results["U-01"]["description"]["bad"]
                    return
        results["U-01"]["status"] = "양호"
        results["U-01"]["message"] = results["U-01"]["description"]["good"]
    except FileNotFoundError:
        results["U-01"]["status"] = "오류"
        results["U-01"]["message"] = "/etc/ssh/sshd_config 파일을 찾을 수 없습니다."

check_permit_root_login()

# 결과를 JSON 파일로 저장
with open('U-01.json', 'w', encoding='utf-8') as f:
    json.dump(results, f, ensure_ascii=False, indent=4)

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
