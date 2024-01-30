import subprocess
import json

# 결과를 저장할 딕셔너리
results = {
    "U-36": {
        "title": "Apache 웹 프로세스 권한 제한",
        "status": "",
        "description": {
            "good": "Apache 데몬이 root 권한으로 구동되지 않는 경우",
            "bad": "Apache 데몬이 root 권한으로 구동되는 경우",
        },
        "message": ""
    }
}

def check_apache_process_permissions():
    try:
        # Apache(httpd) 프로세스의 실행 여부 및 사용자/그룹 확인
        httpd_processes = subprocess.run(["pgrep", "-x", "httpd"], capture_output=True, text=True).stdout.strip().split()
        
        if httpd_processes:
            results["message"] = "Apache 데몬(httpd)이 실행 중입니다."
            for pid in httpd_processes:
                user = subprocess.run(["ps", "-o", "user=", "-p", pid], capture_output=True, text=True).stdout.strip()
                if user == "root":
                    results["status"] = "취약"
                    results["message"] += f" Apache 데몬(httpd)이 루트 권한으로 실행되고 있습니다 (PID: {pid})."
                    break
            else:
                results["status"] = "양호"
                results["message"] += " Apache 데몬(httpd)이 루트 권한으로 실행되지 않습니다."
        else:
            results["status"] = "양호"
            results["message"] = "Apache 데몬(httpd)이 실행되고 있지 않습니다."
    except Exception as e:
        results["status"] = "오류"
        results["message"] = f"Apache 웹 프로세스 권한 검사 중 오류 발생: {e}"

# 검사 수행
check_apache_process_permissions()

# 결과를 JSON 파일로 저장
with open('result.json', 'w', encoding='utf-8') as f:
    json.dump(results, f, ensure_ascii=False, indent=4)

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
