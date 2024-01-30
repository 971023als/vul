import subprocess
import json

# 결과를 저장할 딕셔너리
results = {
    "U-29": {
        "title": "tftp, talk 서비스 비활성화",
        "status": "",
        "description": {
            "good": "tftp, talk, ntalk 서비스가 비활성화 되어 있는 경우",
            "bad": "tftp, talk, ntalk 서비스가 활성화 되어 있는 경우",
        },
        "services": {}
    }
}

def check_service_status(service_name):
    try:
        # 서비스의 활성화 상태 확인
        result = subprocess.run(["systemctl", "is-enabled", service_name], capture_output=True, text=True)
        if result.returncode == 0:
            results["services"][service_name] = "활성화"
            results["status"] = "취약"
        else:
            results["services"][service_name] = "비활성화"
    except Exception as e:
        results["services"][service_name] = f"오류: {str(e)}"

def check_services():
    services = ["tftp", "talk", "ntalk"]
    for service in services:
        check_service_status(service)
    
    if not results["status"]:
        results["status"] = "양호"

# 검사 수행
check_services()

# 결과를 JSON 파일로 저장
with open('result.json', 'w', encoding='utf-8') as f:
    json.dump(results, f, ensure_ascii=False, indent=4)

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
