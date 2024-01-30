#!/usr/bin/env python3
import json
import subprocess

# 결과를 저장할 딕셔너리
results = {
    "U-29": {
        "title": "tftp, talk 서비스 비활성화",
        "status": "",
        "description": {
            "good": "tftp, talk, ntalk 서비스가 비활성화 되어 있는 경우",
            "bad": "tftp, talk, ntalk 서비스가 활성화 되어 있는 경우"
        },
        "details": []
    }
}

services = ["tftp", "talk", "ntalk"]

def check_services_status():
    for service in services:
        try:
            # 서비스가 활성화되어 있는지 확인
            process = subprocess.run(["systemctl", "is-enabled", service], capture_output=True, text=True)
            if process.returncode == 0:
                results["U-29"]["status"] = "취약"
                results["U-29"]["details"].append(f"{service} 서비스가 사용 중입니다.")
            else:
                results["U-29"]["details"].append(f"{service} 서비스가 사용 중이지 않습니다.")
        except Exception as e:
            results["U-29"]["details"].append(f"{service} 서비스 검사 중 오류 발생: {e}")

check_services_status()

# 결과 상태 결정
if "취약" not in results["U-29"]["status"]:
    results["U-29"]["status"] = "양호"

# 결과 파일에 JSON 형태로 저장
result_file = 'tftp_talk_services_disable_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
