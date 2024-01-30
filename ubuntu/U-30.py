import subprocess
import json

# 결과를 저장할 딕셔너리
results = {
    "U-30": {
        "title": "Sendmail 버전 점검",
        "status": "",
        "description": {
            "good": "Sendmail 서비스가 비활성화되어 있거나 최신버전인 경우",
            "bad": "Sendmail 버전이 최신버전이 아닌 경우",
        },
        "message": "",
        "version": ""
    }
}

def check_sendmail_service_and_version():
    try:
        # Sendmail 서비스의 활성화 상태 확인
        service_status = subprocess.run(["systemctl", "is-active", "sendmail"], capture_output=True, text=True)
        if service_status.stdout.strip() == "active":
            results["status"] = "취약"
            results["message"] = "Sendmail 서비스가 실행 중입니다."
            # Sendmail 버전 확인
            version_check = subprocess.run(["sendmail", "-d0.1"], capture_output=True, text=True)
            version_info = version_check.stdout.splitlines()[0] if version_check.stdout else "버전 정보를 확인할 수 없습니다."
            results["version"] = version_info
        else:
            results["status"] = "양호"
            results["message"] = "Sendmail 서비스가 비활성화되어 있습니다."
    except Exception as e:
        results["status"] = "오류"
        results["message"] = f"Sendmail 서비스 및 버전 확인 중 오류 발생: {str(e)}"

# 검사 수행
check_sendmail_service_and_version()

# 결과를 JSON 파일로 저장
with open('result.json', 'w', encoding='utf-8') as f:
    json.dump(results, f, ensure_ascii=False, indent=4)

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
