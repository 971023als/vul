#!/usr/bin/python3
import os
import json

def check_login_warning_messages():
    results = {
        "분류": "시스템 설정",
        "코드": "U-68",
        "위험도": "상",
        "진단 항목": "로그온 시 경고 메시지 제공",
        "진단 결과": "",
        "현황": [],
        "대응방안": "[양호]: 서버 및 Telnet 서비스에 로그온 메시지가 설정되어 있는 경우\n[취약]: 서버 및 Telnet 서비스에 로그온 메시지가 설정되어 있지 않은 경우"
    }

    files = ["/etc/motd", "/etc/issue.net", "/etc/vsftpd/vsftpd.conf", "/etc/mail/sendmail.cf", "/etc/named.conf"]
    missing_files = []

    for file in files:
        if not os.path.exists(file):
            missing_files.append(file)

    if missing_files:
        results["진단 결과"] = "취약"
        results["현황"].append(f"다음 파일이 존재하지 않습니다: {', '.join(missing_files)}")
    else:
        results["진단 결과"] = "양호"
        results["현황"].append("모든 관련 파일이 존재합니다.")

    return results

def main():
    results = check_login_warning_messages()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
