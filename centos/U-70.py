#!/bin/python3

import subprocess
import json
import re

def check_sendmail_service():
    results = []
    # Sendmail 서비스가 실행 중인지 확인합니다.
    try:
        subprocess.check_output(['pgrep', '-f', 'sendmail'], stderr=subprocess.STDOUT)
        sendmail_active = True
    except subprocess.CalledProcessError:
        sendmail_active = False

    # /etc/mail/sendmail.cf 파일에서 noexpn, novrfy 옵션을 확인합니다.
    sendmail_config_file = "/etc/mail/sendmail.cf"
    try:
        with open(sendmail_config_file, 'r') as file:
            config_content = file.read()
        noexpn_set = re.search(r'O\s+NoExpn', config_content) is not None
        novrfy_set = re.search(r'O\s+NoVrfy', config_content) is not None
    except FileNotFoundError:
        noexpn_set = False
        novrfy_set = False

    if sendmail_active and (not noexpn_set or not novrfy_set):
        service_status = "취약"
        message = "SMTP 서비스 사용 중이며, noexpn, novrfy 옵션이 모두 설정되어 있지 않습니다."
    else:
        service_status = "양호"
        message = "SMTP 서비스 미사용 또는, noexpn, novrfy 옵션이 설정되어 있습니다."

    result = {
        "분류": "네트워크 서비스",
        "코드": "U-70",
        "위험도": "높음" if service_status == "취약" else "낮음",
        "진단 항목": "expn, vrfy 명령어 제한",
        "진단 결과": service_status,
        "현황": message,
        "대응방안": "SMTP 서비스 사용 중지 또는 noexpn, novrfy 옵션 설정 권장",
        "결과": "경고" if service_status == "취약" else "정상"
    }

    results.append(result)
    return results

def save_results_to_json(results, file_path):
    with open(file_path, 'w') as f:
        json.dump(results, f, ensure_ascii=False, indent=4)

def main():
    results = check_sendmail_service()
    save_results_to_json(results, "smtp_service_check_result.json")
    print("SMTP 서비스의 expn, vrfy 명령어 사용 제한 여부 점검 결과를 smtp_service_check_result.json 파일에 저장하였습니다.")

if __name__ == "__main__":
    main()
