#!/usr/bin/env python3
import json
import subprocess
import re

# 결과를 저장할 딕셔너리
results = {
    "U-70": {
        "title": "expn, vrfy 명령어 제한",
        "status": "",
        "description": {
            "good": "SMTP 서비스 미사용 또는, noexpn, novrfy 옵션이 설정되어 있는 경우",
            "bad": "SMTP 서비스 사용하고, noexpn, novrfy 옵션이 설정되어 있지 않는 경우"
        },
        "details": []
    }
}

def check_sendmail_service():
    try:
        sendmail_status = subprocess.run(["pgrep", "-f", "sendmail"], capture_output=True, text=True)
        if sendmail_status.returncode == 0:
            results["U-70"]["details"].append("Sendmail 서비스가 실행 중입니다.")
            check_sendmail_config()
        else:
            results["U-70"]["details"].append("Sendmail 서비스가 실행되고 있지 않습니다.")
            results["U-70"]["status"] = "양호"
    except subprocess.SubprocessError as e:
        results["U-70"]["details"].append(f"Sendmail 서비스 상태 확인 중 오류 발생: {e}")

def check_sendmail_config():
    try:
        with open("/etc/mail/sendmail.cf", "r") as file:
            config_content = file.read()
        if all(option in config_content for option in ["O Noexpn", "O Novrfy"]):
            results["U-70"]["details"].append("noexpn, novrfy 옵션이 설정되어 있습니다.")
            results["U-70"]["status"] = "양호"
        else:
            results["U-70"]["details"].append("noexpn, novrfy 옵션이 설정되어 있지 않습니다.")
            results["U-70"]["status"] = "취약"
    except FileNotFoundError:
        results["U-70"]["details"].append("/etc/mail/sendmail.cf 파일이 존재하지 않습니다.")
        results["U-70"]["status"] = "정보"

check_sendmail_service()

# 결과 파일에 JSON 형태로 저장
result_file = 'sendmail_expn_vrfy_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
