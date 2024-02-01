#!/usr/bin/python3
import subprocess
import json

def check_rpc_services_status():
    results = {
        "분류": "시스템 설정",
        "코드": "U-27",
        "위험도": "상",
        "진단 항목": "RPC 서비스 확인",
        "진단 결과": "",
        "현황": [],
        "대응방안": "[양호]: 불필요한 RPC 서비스가 비활성화 되어 있는 경우\n[취약]: 불필요한 RPC 서비스가 활성화 되어 있는 경우"
    }

    services = [
        "rpc.cmsd", "rpc.ttdbserverd", "sadmin", "rusersd", "walld", "sprayd",
        "rstatd", "rpc.nisd", "rexd", "rpc.pcnfsd", "rpc.statd", "rpc.ypupdated",
        "rpc.requotad", "kcms_server", "cachefsd"
    ]

    for service in services:
        try:
            # Using systemctl to check service status
            subprocess.run(['systemctl', 'is-active', service], check=True, stdout=subprocess.PIPE)
            results["현황"].append(f"{service} 서비스가 활성화되어 있습니다.")
            results["진단 결과"] = "취약"
        except subprocess.CalledProcessError:
            results["현황"].append(f"{service} 서비스가 활성화되지 않았습니다.")

    if "진단 결과" not in results:
        results["진단 결과"] = "양호"

    return results

def main():
    results = check_rpc_services_status()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
