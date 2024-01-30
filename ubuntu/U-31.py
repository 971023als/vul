import subprocess
import re
import json

# 결과를 저장할 딕셔너리
results = {
    "U-31": {
        "title": "스팸 메일 릴레이 제한",
        "status": "",
        "description": {
            "good": "SMTP 서비스를 사용하지 않거나 릴레이 제한이 설정되어 있는 경우",
            "bad": "SMTP 서비스를 사용하며 릴레이 제한이 설정되어 있지 않은 경우",
        },
        "message": ""
    }
}

def check_sendmail_relay_restrictions():
    # Sendmail 서비스의 실행 여부 확인
    process = subprocess.run(['pgrep', '-f', 'sendmail'], capture_output=True, text=True)
    if process.stdout.strip():
        # 릴레이 제한 설정 확인
        try:
            with open('/etc/mail/sendmail.cf', 'r') as file:
                config = file.read()
                if re.search(r'R.*relay.*', config):
                    results["status"] = "양호"
                    results["message"] = "릴레이 제한이 설정되어 있습니다."
                else:
                    results["status"] = "취약"
                    results["message"] = "릴레이 제한이 설정되어 있지 않습니다."
        except FileNotFoundError:
            results["status"] = "오류"
            results["message"] = "/etc/mail/sendmail.cf 파일을 찾을 수 없습니다."
    else:
        results["status"] = "양호"
        results["message"] = "Sendmail 서비스가 실행되고 있지 않습니다."

# 검사 수행
check_sendmail_relay_restrictions()

# 결과를 JSON 파일로 저장
with open('result.json', 'w', encoding='utf-8') as f:
    json.dump(results, f, ensure_ascii=False, indent=4)

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
