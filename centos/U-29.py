#!/usr/bin/python3
import subprocess
import json

def check_service_status(service_name):
    try:
        subprocess.run(['systemctl', 'is-enabled', service_name], check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        return True
    except subprocess.CalledProcessError:
        return False

def check_services_disabled():
    results = {
        "분류": "시스템 설정",
        "코드": "U-29",
        "위험도": "상",
        "진단 항목": "tftp, talk 서비스 비활성화",
        "진단 결과": "",
        "현황": [],
        "대응방안": "[양호]: tftp, talk, ntalk 서비스가 비활성화 되어 있는 경우\n[취약]: tftp, talk, ntalk 서비스가 활성화 되어 있는 경우"
    }

    services = ["tftp", "talk", "ntalk"]
    active_services = []

    for service in services:
        if check_service_status(service):
            active_services.append(service)

    if active_services:
        results["진단 결과"] = "취약"
        results["현황"].append(f"활성화된 서비스: {', '.join(active_services)}")
    else:
        results["진단 결과"] = "양호"
        results["현황"].append("tftp, talk, ntalk 서비스가 모두 비활성화되어 있습니다.")

    return results

def main():
    results = check_services_disabled()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
