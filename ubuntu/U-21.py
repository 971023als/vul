#!/usr/bin/python3

import subprocess
import json

def check_r_services_status():
    results = {
        "분류": "서비스 관리",
        "코드": "U-21",
        "위험도": "상",
        "진단 항목": "r 계열 서비스 비활성화",
        "진단 결과": "",
        "현황": [],
        "대응방안": "r 계열 서비스(rlogin, rsh, rexec)를 비활성화하세요."
    }

    services = ['rlogin', 'rsh', 'rexec']
    active_services = []

    for service in services:
        try:
            process = subprocess.run(['systemctl', 'is-active', service], check=False, capture_output=True, text=True)
            if process.returncode == 0:
                active_services.append(service)
        except Exception as e:
            results["현황"].append(f"{service} 서비스 상태 확인 실패: {str(e)}")

    if active_services:
        results["진단 결과"] = "취약"
        results["현황"].append(f"활성화된 r 계열 서비스: {', '.join(active_services)}")
    else:
        results["진단 결과"] = "양호"
        results["현황"].append("r 계열 서비스가 모두 비활성화되어 있습니다.")

    return results

def main():
    results = check_r_services_status()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
