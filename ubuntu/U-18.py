#!/usr/bin/python3

import os
import json

def check_ip_port_restriction():
    results = {
        "분류": "네트워크 서비스 관리",
        "코드": "U-18",
        "위험도": "상",
        "진단 항목": "접속 IP 및 포트 제한",
        "진단 결과": "",
        "현황": [],
        "대응방안": "접속을 수신할 특정 호스트에 대한 IP 주소 및 포트 제한 설정 권장."
    }

    hosts_allow_file = "/etc/hosts.allow"
    hosts_deny_file = "/etc/hosts.deny"
    allow_rules_exist = False
    deny_rules_exist = False

    # Check if /etc/hosts.allow contains non-commented lines
    if os.path.exists(hosts_allow_file):
        with open(hosts_allow_file, 'r') as file:
            for line in file:
                if line.strip() and not line.startswith("#"):
                    allow_rules_exist = True
                    results["현황"].append(f"{hosts_allow_file}에 규칙이 설정되어 있습니다.")
                    break
    
    # Check if /etc/hosts.deny contains non-commented lines
    if os.path.exists(hosts_deny_file):
        with open(hosts_deny_file, 'r') as file:
            for line in file:
                if line.strip() and not line.startswith("#"):
                    deny_rules_exist = True
                    results["현황"].append(f"{hosts_deny_file}에 규칙이 설정되어 있습니다.")
                    break
    
    if allow_rules_exist or deny_rules_exist:
        results["진단 결과"] = "양호"
    else:
        results["진단 결과"] = "취약"
        results["현황"].append("접속 IP 및 포트 제한 규칙이 설정되어 있지 않습니다.")

    return results

def main():
    results = check_ip_port_restriction()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
