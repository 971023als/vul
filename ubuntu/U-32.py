import subprocess
import json

# 결과를 저장할 딕셔너리
results = {
    "U-32": {
        "title": "일반사용자의 Sendmail 실행 방지",
        "status": "",
        "description": {
            "good": "SMTP 서비스 미사용 또는, 일반 사용자의 Sendmail 실행 방지가 설정된 경우",
            "bad": "SMTP 서비스 사용 및 일반 사용자의 Sendmail 실행 방지가 설정되어 있지 않은 경우",
        },
        "message": ""
    }
}

def check_sendmail_service():
    # Sendmail 서비스의 실행 여부 확인
    result = subprocess.run(['pgrep', '-f', 'sendmail'], capture_output=True, text=True)
    if result.stdout.strip():
        results["status"] = "취약"
        results["message"] = "Sendmail 서비스가 실행 중입니다."
    else:
        results["status"] = "양호"
        results["message"] = "Sendmail 서비스가 실행되고 있지 않습니다."

# 검사 수행
check_sendmail_service()

# 결과를 JSON 파일로 저장
with open('result.json', 'w', encoding='utf-8') as f:
    json.dump(results, f, ensure_ascii=False, indent=4)

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
