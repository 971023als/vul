#!/usr/bin/env python3
import json
import re

# 결과를 저장할 딕셔너리
results = {
    "U-71": {
        "title": "Apache 웹서비스 정보 숨김",
        "status": "",
        "description": {
            "good": "ServerTokens Prod, ServerSignature Off로 설정되어있는 경우",
            "bad": "ServerTokens Prod, ServerSignature Off로 설정되어있지 않은 경우"
        },
        "details": []
    }
}

def check_apache_config():
    filename = "/etc/apache2/apache2.conf"
    
    try:
        with open(filename, 'r') as file:
            config_content = file.read()
        
        server_tokens = re.search(r'^\s*ServerTokens\s+Prod\s*$', config_content, re.MULTILINE | re.IGNORECASE)
        server_signature = re.search(r'^\s*ServerSignature\s+Off\s*$', config_content, re.MULTILINE | re.IGNORECASE)
        
        if server_tokens and server_signature:
            results["U-71"]["status"] = "양호"
            results["U-71"]["details"].append("ServerTokens Prod 및 ServerSignature Off로 설정되어 있습니다.")
        else:
            results["U-71"]["status"] = "취약"
            if not server_tokens:
                results["U-71"]["details"].append("ServerTokens 설정이 Prod로 설정되지 않았습니다.")
            if not server_signature:
                results["U-71"]["details"].append("ServerSignature 설정이 Off로 설정되지 않았습니다.")
    except FileNotFoundError:
        results["U-71"]["status"] = "취약"
        results["U-71"]["details"].append(f"{filename} 가 존재하지 않습니다.")

check_apache_config()

# 결과 파일에 JSON 형태로 저장
result_file = 'apache_web_service_info_hiding_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
