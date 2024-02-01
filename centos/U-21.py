#!/usr/bin/python3
import json
import os

def check_r_services_disabled():
    results = {
        "분류": "시스템 설정",
        "코드": "U-21",
        "위험도": "상",
        "진단 항목": "r 계열 서비스 비활성화",
        "진단 결과": "",
        "현황": [],
        "대응방안": "[양호]: r 계열 서비스가 비활성화 되어 있는 경우\n[취약]: r 계열 서비스가 활성화 되어 있는 경우"
    }

    service_files = ['/etc/xinetd.d/rlogin', '/etc/xinetd.d/rsh', '/etc/xinetd.d/rexec']
    expected_settings = [
        "socket_type= stream",
        "wait= no",
        "user= nobody",
        "log_on_success+= USERID",
        "log_on_failure+= USERID",
        "disable= yes"
    ]

    for service_file in service_files:
        if os.path.exists(service_file):
            with open(service_file, 'r') as f:
                content = f.read()
                all_settings_ok = True
                for setting in expected_settings:
                    if setting not in content:
                        all_settings_ok = False
                        results["현황"].append(f"{service_file} 파일에서 '{setting}'을 올바르게 설정하지 않았습니다.")
                        break
                if all_settings_ok:
                    results["현황"].append(f"'{service_file}' 파일의 설정이 올바릅니다.")
        else:
            results["현황"].append(f"{service_file} 파일이 없습니다.")

    if not results["현황"]:
        results["진단 결과"] = "양호"
    else:
        results["진단 결과"] = "취약"

    return results

def main():
    results = check_r_services_disabled()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
