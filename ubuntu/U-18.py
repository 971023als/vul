import os
import json

# 결과를 저장할 딕셔너리
results = {
    "U-18": {
        "title": "접속 IP 및 포트 제한",
        "status": "",
        "description": {
            "good": "접속을 허용할 특정 호스트에 대한 IP 주소 및 포트 제한을 설정한 경우",
            "bad": "접속을 허용할 특정 호스트에 대한 IP 주소 및 포트 제한을 설정하지 않은 경우",
        },
        "message": ""
    }
}

def check_host_restrictions():
    allow_file = "/etc/hosts.allow"
    deny_file = "/etc/hosts.deny"
    allow_rules = deny_rules = False
    
    # /etc/hosts.allow 파일 검사
    if os.path.exists(allow_file):
        with open(allow_file, 'r') as f:
            for line in f:
                if line.strip() and not line.startswith("#"):
                    allow_rules = True
                    break
    
    # /etc/hosts.deny 파일 검사
    if os.path.exists(deny_file):
        with open(deny_file, 'r') as f:
            for line in f:
                if line.strip() and not line.startswith("#"):
                    deny_rules = True
                    break
    
    if allow_rules and deny_rules:
        results["U-18"]["status"] = "양호"
        results["U-18"]["message"] = results["U-18"]["description"]["good"]
    else:
        results["U-18"]["status"] = "취약"
        results["U-18"]["message"] = results["U-18"]["description"]["bad"]

# 검사 수행
check_host_restrictions()

# 결과를 JSON 파일로 저장
with open('result.json', 'w', encoding='utf-8') as f:
    json.dump(results, f, ensure_ascii=False, indent=4)

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
