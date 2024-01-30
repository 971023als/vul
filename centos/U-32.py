#!/usr/bin/env python3
import json
import subprocess

# 결과를 저장할 딕셔너리
results = {
    "U-32": {
        "title": "일반사용자의 Sendmail 실행 방지",
        "status": "",
        "description": {
            "good": "SMTP 서비스 미사용 또는, 일반 사용자의 Sendmail 실행 방지가 설정된 경우",
            "bad": "SMTP 서비스 사용 및 일반 사용자의 Sendmail 실행 방지가 설정되어 있지 않은 경우"
        },
        "details": []
    }
}

def check_sendmail_service():
    try:
        # Sendmail 서비스가 실행 중인지 확인
        process = subprocess.run(["pgrep", "-f", "sendmail"], capture_output=True, text=True)
        if process.returncode == 0:
            results["U-32"]["status"] = "취약"
            results["U-32"]["details"].append("Sendmail 서비스가 실행 중입니다.")
            # 여기에 일반 사용자의 Sendmail 실행 방지 설정 확인 로직 추가 가능
        else:
            results["U-32"]["status"] = "양호"
            results["U-32"]["details"].append("Sendmail 서비스가 실행되고 있지 않습니다.")
    except Exception as e:
        results["U-32"]["details"].append(f"Sendmail 서비스 검사 중 오류 발생: {e}")

check_sendmail_service()

# 결과 파일에 JSON 형태로 저장
result_file = 'sendmail_execution_prevention_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
