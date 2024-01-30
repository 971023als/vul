#!/usr/bin/env python3
import json
import subprocess

# 결과를 저장할 딕셔너리
results = {
    "U-33": {
        "title": "DNS 보안 버전 패치",
        "status": "",
        "description": {
            "good": "DNS 서비스를 사용하지 않거나 주기적으로 패치를 관리하고 있는 경우",
            "bad": "DNS 서비스를 사용하며 주기적으로 패치를 관리하고 있지 않는 경우"
        },
        "details": []
    }
}

def check_dns_service():
    try:
        # 'named' 프로세스가 실행 중인지 확인
        process = subprocess.run(["pgrep", "-f", "named"], capture_output=True, text=True)
        if process.returncode == 0:
            results["U-33"]["status"] = "취약"
            results["U-33"]["details"].append("DNS 서비스가 실행 중입니다.")
        else:
            results["U-33"]["status"] = "양호"
            results["U-33"]["details"].append("DNS 서비스가 실행되고 있지 않습니다.")
    except Exception as e:
        results["U-33"]["details"].append(f"DNS 서비스 검사 중 오류 발생: {e}")

check_dns_service()

# 결과 파일에 JSON 형태로 저장
result_file = 'dns_security_patch_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
