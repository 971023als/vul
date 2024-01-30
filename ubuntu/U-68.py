#!/usr/bin/env python3
import json
import os

# 결과를 저장할 딕셔너리
results = {
    "U-68": {
        "title": "로그온 시 경고 메시지 제공",
        "status": "",
        "description": {
            "good": "서버 및 Telnet 서비스에 로그온 메시지가 설정되어 있는 경우",
            "bad": "서버 및 Telnet 서비스에 로그온 메시지가 설정되어 있지 않은 경우"
        },
        "details": []
    }
}

def check_login_messages():
    files = ["/etc/motd", "/etc/issue.net", "/etc/vsftpd/vsftpd.conf", "/etc/mail/sendmail.cf", "/etc/named.conf"]
    missing_files = []

    for file in files:
        if not os.path.exists(file):
            missing_files.append(file)
    
    if missing_files:
        results["U-68"]["status"] = "취약"
        results["U-68"]["details"].append(f"존재하지 않는 파일들: {', '.join(missing_files)}")
    else:
        results["U-68"]["status"] = "양호"
        results["U-68"]["details"].append("모든 필수 로그온 메시지 파일들이 존재합니다.")

check_login_messages()

# 결과 파일에 JSON 형태로 저장
result_file = 'login_message_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
