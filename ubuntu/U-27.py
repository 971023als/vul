#!/usr/bin/python3
import subprocess
import json

def check_rpc_services_status():
    results = {
        "분류": "시스템 관리",
        "코드": "U-27",
        "위험도": "상",
        "진단 항목": "RPC 서비스 확인",
        "진단 결과": "",
        "현황": [],
        "대응방안": "[양호]: 불필요한 RPC 서비스가 비활성화 되어 있는 경우\n[취약]: 불필요한 RPC 서비스가 활성화 되어 있는 경우"
    }

    services = ["rpc.cmsd", "rpc.ttdbserverd", "sadmin", "rusersd", "walld", "sprayd", "rstatd", "rpc.nisd", "rexd", "rpc.pcnfsd", "rpc.statd", "rpc.ypupdated", "rpc.requotad", "kcms_server", "cachefsd"]

    for service in services:
        try:
            # `systemctl` 명령을 사용하여 서비스 상태를 확인합니다.
            subprocess.check_call(["systemctl", "status", service], stdout=subprocess.DEVNULL, stderr=subprocess.STDOUT)
            results["현황"].append(f"{service} 서비스가 활성")
            results["진단 결과"] = "취약"
        except subprocess.CalledProcessError:
            results["현황"].append(f"{service} 서비스가 활성화되지 않았습니다.")
            if results["진단 결과"] != "취약":
                results["진단 결과"] = "양호"

    return results

def main():
    results = check_rpc_services_status()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
