#!/bin/python3

import re
import json

# 결과 저장을 위한 딕셔너리
results = {
    "분류": "서비스 관리",
    "코드": "U-71",
    "위험도": "상",
    "진단 항목": "Apache 웹서비스 정보 숨김",
    "진단 결과": "",
    "현황": [],
    "대응방안": "httpd.conf 파일에서 ServerTokens를 'Prod'로, ServerSignature를 'Off'로 설정하세요."
}

# Apache 설정 파일 경로
filename = "/etc/httpd/conf/httpd.conf"

try:
    # 설정 파일 읽기
    with open(filename, 'r') as file:
        content = file.read()
        
    # ServerTokens 설정 검사
    server_tokens = re.search(r'^ServerTokens\s+Prod', content, re.MULTILINE | re.IGNORECASE)
    if server_tokens:
        results["현황"].append("ServerTokens 설정이 'Prod'로 적절하게 설정되었습니다.")
    else:
        results["현황"].append("ServerTokens 설정이 'Prod'로 설정되지 않았습니다.")
        results["진단 결과"] = "취약"

    # ServerSignature 설정 검사
    server_signature = re.search(r'^ServerSignature\s+Off', content, re.MULTILINE | re.IGNORECASE)
    if server_signature:
        results["현황"].append("ServerSignature 설정이 'Off'로 적절하게 설정되었습니다.")
    else:
        results["현황"].append("ServerSignature 설정이 'Off'로 설정되지 않았습니다.")
        results["진단 결과"] = "취약"

    # 모두 적절하게 설정된 경우
    if server_tokens and server_signature:
        results["진단 결과"] = "양호"

except FileNotFoundError:
    results["현황"].append(f"{filename} 파일이 존재하지 않습니다.")
    results["진단 결과"] = "정보 부족"

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
