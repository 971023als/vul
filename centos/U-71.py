#!/bin/python3

import re
import json

def check_apache_web_service_hiding():
    results = []
    filename = "/etc/httpd/conf/httpd.conf"

    try:
        with open(filename, 'r') as file:
            config_content = file.read()
        
        server_tokens = re.search(r'^ServerTokens\s+Prod$', config_content, re.MULTILINE | re.IGNORECASE)
        server_signature = re.search(r'^ServerSignature\s+Off$', config_content, re.MULTILINE | re.IGNORECASE)
        
        if server_tokens:
            tokens_status = "양호"
            tokens_message = "서버 토큰 설정이 Prod로 설정되었습니다."
        else:
            tokens_status = "취약"
            tokens_message = "서버 토큰 설정이 Prod로 설정되지 않았습니다."
        
        if server_signature:
            signature_status = "양호"
            signature_message = "Server Signature 설정이 Off로 설정되었습니다."
        else:
            signature_status = "취약"
            signature_message = "Server Signature 설정이 Off로 설정되지 않았습니다."
        
        results.append({
            "분류": "웹서비스 보안",
            "코드": "U-71",
            "위험도": "높음" if tokens_status == "취약" or signature_status == "취약" else "낮음",
            "진단 항목": "Apache 웹서비스 정보 숨김",
            "진단 결과": ", ".join([tokens_status, signature_status]),
            "현황": ", ".join([tokens_message, signature_message]),
            "대응방안": "ServerTokens와 ServerSignature 설정을 권장 값으로 변경",
            "결과": "경고" if tokens_status == "취약" or signature_status == "취약" else "정상"
        })

    except FileNotFoundError:
        results.append({
            "분류": "웹서비스 보안",
            "코드": "U-71",
            "위험도": "정보",
            "진단 항목": "Apache 웹서비스 정보 숨김",
            "진단 결과": "정보",
            "현황": f"{filename} 가 존재하지 않습니다.",
            "대응방안": "Apache 설치 확인 및 필요한 보안 설정 적용",
            "결과": "정보"
        })

    return results

def save_results_to_json(results, file_path):
    with open(file_path, 'w') as f:
        json.dump(results, f, ensure_ascii=False, indent=4)

def main():
    results = check_apache_web_service_hiding()
    save_results_to_json(results, "apache_web_service_hiding_check_result.json")
    print("Apache 웹서비스 정보 숨김 설정 점검 결과를 apache_web_service_hiding_check_result.json 파일에 저장하였습니다.")

if __name__ == "__main__":
    main()
