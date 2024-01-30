#!/usr/bin/env python3
import json
import os

# 결과를 저장할 딕셔너리
results = {
    "U-05": {
        "title": "root 홈, 패스 디렉토리 권한 및 패스 설정",
        "status": "",
        "description": {
            "good": "PATH 환경변수에 '.' 이 맨 앞이나 중간에 포함되지 않은 경우",
            "bad": "PATH 환경변수에 '.' 이 맨 앞이나 중간에 포함되어 있는 경우"
        },
        "details": []
    }
}

def check_path_environment():
    path = os.environ.get('PATH', '')
    
    if path.startswith('.'):
        results["U-05"]["status"] = "취약"
        results["U-05"]["details"].append("PATH 변수의 시작 부분에서 '.' 발견됨.")
    elif ':.' in path:
        results["U-05"]["status"] = "취약"
        results["U-05"]["details"].append("PATH 변수의 중간 부분에서 '.' 발견됨.")
    else:
        results["U-05"]["status"] = "양호"
        results["U-05"]["details"].append("PATH 변수에 '.' 이 맨 앞이나 중간에 포함되지 않음.")

check_path_environment()

# 결과 파일에 JSON 형태로 저장
result_file = 'path_environment_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
