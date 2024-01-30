#!/usr/bin/env python3
import json
import subprocess

# 결과를 저장할 딕셔너리
results = {
    "U-34": {
        "title": "DNS Zone Transfer 설정",
        "status": "",
        "description": {
            "good": "DNS 서비스 미사용 또는, Zone Transfer를 허가된 사용자에게만 허용한 경우",
            "bad": "DNS 서비스를 사용하여 Zone Transfer를 모든 사용자에게 허용한 경우"
        },
        "details": []
    }
}

def check_dns_service():
    try:
        # 'named' 프로세스가 실행 중인지 확인
        process = subprocess.run(["pgrep", "-f", "named"], capture_output=True, text=True)
        if process.returncode == 0:
            results["U-34"]["status"] = "취약"
            results["U-34"]["details"].append("DNS 서비스 데몬이 실행 중입니다.")
            # 추가: Zone Transfer 설정 확인 로직 (실제 환경에 따라 다름)
        else:
            results["U-34"]["status"] = "양호"
            results["U-34"]["details"].append("DNS 서비스 데몬이 실행되고 있지 않습니다.")
    except Exception as e:
        results["U-34"]["details"].append(f"DNS 서비스 검사 중 오류 발생: {e}")

check_dns_service()

# 결과 파일에 JSON 형태로 저장
result_file = 'dns_zone_transfer_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
