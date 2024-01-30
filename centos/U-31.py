#!/usr/bin/env python3
import json
import subprocess

# 결과를 저장할 딕셔너리
results = {
    "U-31": {
        "title": "스팸 메일 릴레이 제한",
        "status": "",
        "description": {
            "good": "SMTP 서비스를 사용하지 않거나 릴레이 제한이 설정되어 있는 경우",
            "bad": "SMTP 서비스를 사용하며 릴레이 제한이 설정되어 있지 않은 경우"
        },
        "details": []
    }
}

def check_sendmail_service():
    try:
        # Sendmail 서비스가 실행 중인지 확인
        process = subprocess.run(["pgrep", "-f", "sendmail"], capture_output=True, text=True)
        if process.returncode == 0:
            results["U-31"]["status"] = "취약"
            results["U-31"]["details"].append("Sendmail 서비스가 실행 중입니다.")
            # 추가적으로 릴레이 설정 확인이 필요하지만, 본 스크립트에서는 실행 상태만 확인합니다.
        else:
            results["U-31"]["status"] = "양호"
            results["U-31"]["details"].append("Sendmail 서비스가 실행되고 있지 않습니다.")
    except Exception as e:
        results["U-31"]["details"].append(f"Sendmail 서비스 검사 중 오류 발생: {e}")

check_sendmail_service()

# 결과 파일에 JSON 형태로 저장
result_file = 'smtp_relay_restriction_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
