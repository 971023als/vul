#!/usr/bin/python3
import re
import json

def check_apache_web_service_info_hiding():
    results = {
        "분류": "시스템 설정",
        "코드": "U-71",
        "위험도": "상",
        "진단 항목": "Apache 웹서비스 정보 숨김",
        "진단 결과": "",
        "현황": [],
        "대응방안": "[양호]: ServerTokens Prod, ServerSignature Off로 설정되어있는 경우\n[취약]: ServerTokens Prod, ServerSignature Off로 설정되어있지 않은 경우"
    }

    filename = "/etc/apache2/apache2.conf"
    try:
        with open(filename, 'r') as file:
            content = file.read()
            server_tokens = re.search(r'^\s*ServerTokens\s+Prod\s*$', content, re.MULTILINE)
            server_signature = re.search(r'^\s*ServerSignature\s+Off\s*$', content, re.MULTILINE)

            if server_tokens:
                results["현황"].append("서버 토큰 설정이 Prod로 설정되었습니다.")
            else:
                results["진단 결과"] = "취약"
                results["현황"].append("서버 토큰 설정이 Prod로 설정되지 않았습니다.")

            if server_signature:
                results["현황"].append("Server Signature 설정이 Off로 설정되었습니다.")
            else:
                results["진단 결과"] = "취약"
                results["현황"].append("Server Signature 설정이 Off로 설정되지 않았습니다.")
    except FileNotFoundError:
        results["진단 결과"] = "취약"
        results["현황"].append(f"{filename} 파일이 존재하지 않습니다.")

    return results

def main():
    results = check_apache_web_service_info_hiding()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
