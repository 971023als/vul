#!/usr/bin/python3
import subprocess
import os
import json

def check_ssh_telnet_services():
    results = {
        "분류": "서비스 관리",
        "코드": "U-60",
        "위험도": "중",
        "진단 항목": "ssh 원격접속 허용",
        "진단 결과": "양호",  # Assume "Good" until proven otherwise
        "현황": {"SSH 서비스 상태": "비활성화", "Telnet 서비스 상태": "비활성화", "FTP 서비스 상태": "비활성화"},
        "대응방안": "SSH 사용 권장, Telnet 및 FTP 사용하지 않도록 설정"
    }

    # Check for SSH service
    ssh_status = subprocess.run(['systemctl', 'is-active', 'ssh'], stdout=subprocess.PIPE, text=True)
    if ssh_status.stdout.strip() == 'active':
        results["현황"]["SSH 서비스 상태"] = "활성화"
    else:
        results["진단 결과"] = "취약"
        results["현황"]["SSH 서비스 상태"] = "비활성화"

    # Check for Telnet service
    telnet_check = subprocess.run(['pgrep', '-f', 'telnetd'], stdout=subprocess.PIPE)
    if telnet_check.stdout:
        results["진단 결과"] = "취약"
        results["현황"]["Telnet 서비스 상태"] = "활성화"

    # Check for FTP service
    ftp_check = subprocess.run(['pgrep', '-f', 'ftpd'], stdout=subprocess.PIPE)
    if ftp_check.stdout:
        results["진단 결과"] = "취약"
        results["현황"]["FTP 서비스 상태"] = "활성화"

    return results

def main():
    security_check_results = check_ssh_telnet_services()
    print(security_check_results)

if __name__ == "__main__":
    main()
