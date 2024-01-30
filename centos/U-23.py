#!/usr/bin/env python3
import json
import os
import glob

# 결과를 저장할 딕셔너리
results = {
    "U-23": {
        "title": "DoS 공격에 취약한 서비스 비활성화",
        "status": "",
        "description": {
            "good": "DoS 공격에 취약한 서비스가 비활성화된 경우",
            "bad": "DoS 공격에 취약한 서비스가 활성화된 경우"
        },
        "details": []
    }
}

def check_service_disabled(service_patterns):
    for pattern in service_patterns:
        for file_path in glob.glob(pattern):
            with open(file_path, 'r') as file:
                if "disable = yes" in file.read():
                    results["U-23"]["details"].append(f"{file_path} 파일에 대한 서비스가 비활성화 되어 있습니다.")
                else:
                    results["U-23"]["status"] = "취약"
                    results["U-23"]["details"].append(f"{file_path} 파일에 대한 서비스가 활성화 되어 있습니다.")

service_patterns = [
    "/etc/xinetd.d/echo*",
    "/etc/xinetd.d/discard*",
    "/etc/xinetd.d/daytime*",
    "/etc/xinetd.d/chargen*"
]
check_service_disabled(service_patterns)

# 결과 상태 결정
if "취약" not in results["U-23"]["status"]:
    results["U-23"]["status"] = "양호"

# 결과 파일에 JSON 형태로 저장
result_file = 'dos_vulnerable_services_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
