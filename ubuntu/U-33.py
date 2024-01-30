import subprocess
import json

# 결과를 저장할 딕셔너리
results = {
    "U-33": {
        "title": "DNS 보안 버전 패치",
        "status": "",
        "description": {
            "good": "DNS 서비스를 사용하지 않거나 주기적으로 패치를 관리하고 있는 경우",
            "bad": "DNS 서비스를 사용하며 주기적으로 패치를 관리하고 있지 않는 경우",
        },
        "message": ""
    }
}

def check_dns_service():
    # DNS 서비스(named 프로세스)의 실행 여부 확인
    process = subprocess.run(['pgrep', '-f', 'named'], capture_output=True, text=True)
    if process.stdout.strip():
        results["status"] = "취약"
        results["message"] = "DNS 서비스가 실행 중입니다."
    else:
        results["status"] = "양호"
        results["message"] = "DNS 서비스가 실행되고 있지 않습니다."

# 검사 수행
check_dns_service()

# 결과를 JSON 파일로 저장
with open('result.json', 'w', encoding='utf-8') as f:
    json.dump(results, f, ensure_ascii=False, indent=4)

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
