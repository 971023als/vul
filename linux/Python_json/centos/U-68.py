#!/usr/bin/python3
import subprocess
import os
import json

def check_login_message():
    results = {
        "분류": "서비스 관리",
        "코드": "U-68",
        "위험도": "하",
        "진단 항목": "로그온 시 경고 메시지 제공",
        "진단 결과": "양호",  # Assume "Good" until proven otherwise
        "현황": [],
        "대응방안": "서버 및 주요 서비스(Telnet, FTP, SMTP, DNS)에 로그온 메시지 설정"
    }

    # Check /etc/motd for login message
    if os.path.exists('/etc/motd'):
        with open('/etc/motd', 'r') as file:
            if not file.read().strip():
                results["진단 결과"] = "취약"
                results["현황"].append("/etc/motd 파일에 로그온 메시지를 설정하지 않았습니다.")
    else:
        results["진단 결과"] = "취약"
        results["현황"].append("/etc/motd 파일이 없습니다.")

    # Check for /etc/issue.net for Telnet and FTP services
    if os.path.exists('/etc/issue.net'):
        with open('/etc/issue.net', 'r') as file:
            if not file.read().strip():
                results["진단 결과"] = "취약"
                results["현황"].append("/etc/issue.net 파일에 로그온 메시지를 설정하지 않았습니다.")
    else:
        results["진단 결과"] = "취약"
        results["현황"].append("/etc/issue.net 파일이 없습니다.")

    # Additional checks for FTP service configurations
    ftp_configs = ['/etc/vsftpd.conf', '/etc/proftpd/proftpd.conf', '/etc/pure-ftpd/conf/WelcomeMsg']
    for config in ftp_configs:
        if os.path.exists(config):
            with open(config, 'r') as file:
                content = file.read().strip()
                if 'ftpd_banner' not in content and 'ServerIdent' not in content and 'WelcomeMsg' not in content:
                    results["진단 결과"] = "취약"
                    results["현황"].append(f"{config} 파일에 로그온 메시지를 설정하지 않았습니다.")

    # SMTP service configuration check in sendmail.cf
    if os.path.exists('/etc/sendmail.cf'):
        with open('/etc/sendmail.cf', 'r') as file:
            if 'GreetingMessage' not in file.read():
                results["진단 결과"] = "취약"
                results["현황"].append("/etc/sendmail.cf 파일에 로그온 메시지를 설정하지 않았습니다.")

    # Note for DNS service configuration check
    results["현황"].append("DNS 배너의 경우 '/etc/named.conf' 또는 '/var/named' 파일을 수동으로 점검하세요.")

    return results

def main():
    login_message_check_results = check_login_message()
    print(login_message_check_results)

if __name__ == "__main__":
    main()
