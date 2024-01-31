#!/bin/python3

import os
import json
import glob

# 결과 리스트 초기화
results = []

# 검사할 서비스 목록
services = ["echo", "discard", "daytime", "chargen"]

def check_service_status(service):
    """
    주어진 서비스에 대해 상태를 검사하고 결과를 반환합니다.
    """
    files = glob.glob(f"/etc/xinetd.d/{service}*")
    if not files:
        print(f"/etc/xinetd.d/{service} 파일이 존재하지 않습니다.")
        return "OK", f"/etc/xinetd.d/{service} 파일이 존재하지 않습니다."
    
    for file in files:
        print(f"{file} 파일이 존재합니다.")
        with open(file) as f:
            for line in f:
                if "disable" in line:
                    status = line.split()[-1]
                    if status == "yes":
                        print(f"{file} 파일에 대한 서비스가 비활성화 되어 있습니다.")
                        return "OK", f"{file} 파일에 대한 서비스가 비활성화 되어 있습니다."
                    else:
                        print(f"{file} 파일에 대한 서비스가 활성화 되어 있습니다.")
                        return "WARN", f"{file} 파일에 대한 서비스가 활성화 되어 있습니다."
    return "N/A", "상태를 확인할 수 없습니다."

# 각 서비스에 대해 검사 실행
for service in services:
    status, message = check_service_status(service)
    if status == "OK":
        result_status = "양호"
    else:
        result_status = "취약"
    
    results.append({
        "분류": "서비스 관리",
        "코드": "U-23",
        "위험도": "상",
        "진단 항목": f"DoS 공격에 취약한 {service} 서비스 비활성화",
        "진단 결과": result_status,
        "현황": message,
        "대응방안": "xinetd 사용시에 파일의 소유자 및 권한 설정"
    })

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))