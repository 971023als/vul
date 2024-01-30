#!/usr/bin/env python3
import json
import subprocess

# 결과를 저장할 딕셔너리
results = {
    "U-18": {
        "title": "접속 IP 및 포트 제한",
        "status": "",
        "description": {
            "good": "/etc/hosts.deny 파일에 ALL: DENY 설정 후 /etc/hosts.allow 파일에 접근을 허용할 특정 호스트를 등록한 경우",
            "bad": "위와 같이 설정되지 않은 경우"
        },
        "details": []
    }
}

def check_hosts_restrictions():
    # /etc/hosts.allow 파일의 내용을 확인
    try:
        with open("/etc/hosts.allow", "r") as file:
            hosts_allow_content = file.read()
    except FileNotFoundError:
        hosts_allow_content = ""
    
    # /etc/hosts.deny 파일의 내용을 확인
    try:
        with open("/etc/hosts.deny", "r") as file:
            hosts_deny_content = file.read()
    except FileNotFoundError:
        hosts_deny_content = ""
    
    # 조건을 확인하고 결과를 설정
    if "ALL: DENY" in hosts_deny_content and hosts_allow_content.strip():
        results["U-18"]["status"] = "양호"
        results["U-18"]["details"].append("적절한 IP 주소 및 포트 제한 설정이 적용되어 있습니다.")
    else:
        results["U-18"]["status"] = "취약"
        results["U-18"]["details"].append("IP 주소 및 포트 제한 설정이 적절히 적용되지 않았습니다.")

check_hosts_restrictions()

# 결과 파일에 JSON 형태로 저장
result_file = 'ip_port_restriction_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
