#!/usr/bin/python3
import os
import json

def check_dos_vulnerable_services_disabled():
    results = {
        "분류": "시스템 설정",
        "코드": "U-23",
        "위험도": "상",
        "진단 항목": "DoS 공격에 취약한 서비스 비활성화",
        "진단 결과": "",
        "현황": [],
        "대응방안": "[양호]: DoS 공격에 취약한 서비스가 비활성화 된 경우\n[취약]: DoS 공격에 취약한 서비스 활성화 된 경우"
    }

    services = ['echo', 'discard', 'daytime', 'chargen']
    xinetd_dir = '/etc/xinetd.d/'

    for service in services:
        service_files = [f for f in os.listdir(xinetd_dir) if f.startswith(service)]
        if not service_files:
            results["현황"].append(f"{service} 서비스 파일이 존재하지 않습니다.")
            continue

        for service_file in service_files:
            file_path = os.path.join(xinetd_dir, service_file)
            with open(file_path, 'r') as f:
                if 'disable = yes' in f.read():
                    results["현황"].append(f"{service_file} 서비스가 비활성화 되어 있습니다.")
                else:
                    results["진단 결과"] = "취약"
                    results["현황"].append(f"{service_file} 서비스가 활성화 되어 있습니다.")

    if "진단 결과" not in results:
        results["진단 결과"] = "양호"

    return results

def main():
    results = check_dos_vulnerable_services_disabled()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
