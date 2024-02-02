#!/usr/bin/python3
import os
import subprocess
import re

def check_remote_root_access_restriction():
    results = {
        "분류": "계정관리",
        "코드": "U-01",
        "위험도": "상",
        "진단 항목": "root 계정 원격접속 제한",
        "진단 결과": "",
        "현황": [],
        "대응방안": "원격 터미널 서비스 사용 시 root 직접 접속을 차단"
    }

    # Telnet 서비스 검사
    telnet_status = subprocess.getoutput("grep -vE '^#|^\s#' /etc/services | awk 'tolower($1)==\"telnet\" {print $2}' | awk -F / 'tolower($2)==\"tcp\" {print $1}' | wc -l")
    if int(telnet_status) > 0:
        results["현황"].append("Telnet 서비스 포트가 활성화되어 있습니다.")
        results["진단 결과"] = "취약"

    # SSH 서비스 검사
    sshd_configs = subprocess.getoutput("find / -name 'sshd_config' -type f 2>/dev/null").splitlines()
    permit_root_login = False
    for sshd_config in sshd_configs:
        with open(sshd_config, 'r') as file:
            for line in file:
                if re.match(r'^PermitRootLogin\s+no', line, re.I):
                    permit_root_login = True
                    break

    if not permit_root_login and sshd_configs:
        results["현황"].append("SSH 서비스에서 root 계정의 원격 접속이 허용되고 있습니다.")
        results["진단 결과"] = "취약"
    elif sshd_configs:
        results["현황"].append("SSH 서비스에서 root 계정의 원격 접속이 제한되어 있습니다.")
        results["진단 결과"] = "양호"
    else:
        results["현황"].append("SSH 서비스 설정 파일(sshd_config)을 찾을 수 없습니다.")
        results["진단 결과"] = "취약"

    return results

def main():
    results = check_remote_root_access_restriction()
    print(results)

if __name__ == "__main__":
    main()
