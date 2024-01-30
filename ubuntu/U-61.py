#!/usr/bin/env python3
import json
import subprocess
import re
import socket

# 결과를 저장할 딕셔너리
results = {
    "U-61": {
        "title": "ftp 서비스 확인",
        "status": "",
        "description": {
            "good": "FTP 서비스가 비활성화 되어 있는 경우",
            "bad": "FTP 서비스가 활성화 되어 있는 경우"
        },
        "details": []
    }
}

def check_ftp_service():
    try:
        # FTP 계정 존재 여부 확인
        with open('/etc/passwd', 'r') as f:
            passwd_content = f.read()
        ftp_entry = re.search(r'^ftp:', passwd_content, re.MULTILINE)
        
        if ftp_entry:
            ftp_shell = re.search(r'^ftp:.*:(/bin/false)$', passwd_content, re.MULTILINE)
            if ftp_shell:
                results["U-61"]["details"].append("FTP 계정의 셸이 /bin/false로 설정되었습니다.")
            else:
                results["U-61"]["status"] = "취약"
                results["U-61"]["details"].append("FTP 계정의 셸을 /bin/false로 설정할 수 없습니다.")
        else:
            results["U-61"]["details"].append("FTP 계정이 존재하지 않습니다.")
        
        # FTP 포트 수신 상태 확인
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            if s.connect_ex(('localhost', 21)) == 0:
                results["U-61"]["status"] = "취약"
                results["U-61"]["details"].append("FTP 포트(21)가 열려 있습니다.")
            else:
                results["U-61"]["details"].append("FTP 포트(21)가 열려 있지 않습니다.")
                if results["U-61"]["status"] != "취약":
                    results["U-61"]["status"] = "양호"
    except Exception as e:
        results["U-61"]["details"].append(f"오류 발생: {str(e)}")

check_ftp_service()

# 결과 파일에 JSON 형태로 저장
result_file = 'ftp_service_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
