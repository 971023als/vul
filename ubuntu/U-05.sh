import os
import json
import re

# 결과를 저장할 딕셔너리
results = {
    "U-05": {
        "title": "root 홈, 패스 디렉토리 권한 및 패스 설정",
        "status": "",
        "description": {
            "good": "PATH 환경변수에 '.' 이 맨 앞이나 중간에 포함되지 않은 경우",
            "bad": "PATH 환경변수에 '.' 이 맨 앞이나 중간에 포함되어 있는 경우"
        },
        "message": ""
    }
}

def check_path_environment_variable():
    path_env = os.getenv('PATH', '')
    # 경로 시작 부분에 '.'이 있는지 확인
    if path_env.startswith('.'):
        results["U-05"]["status"] = "취약"
        results["U-05"]["message"] += "PATH 변수의 시작 부분에서 '.' 발견됨. "
    else:
        results["U-05"]["message"] += "PATH 변수의 시작 부분에서 '.' 발견 안 됨. "

    # 경로 중간에 '.'이 있는지 확인
    if re.search(r':\.', path_env):
        results["U-05"]["status"] = "취약"
        results["U-05"]["message"] += "PATH 변수의 중간 부분에서 '.' 발견됨."
    else:
        results["U-05"]["message"] += "PATH 변수의 중간 부분에서 '.' 발견 안 됨."

    if "취약" not in results["U-05"]["status"]:
        results["U-05"]["status"] = "양호"

# 검사 수행
check_path_environment_variable()

# 결과를 JSON 파일로 저장
with open('U-05.json', 'w', encoding='utf-8') as f:
    json.dump(results, f, ensure_ascii=False, indent=4)

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
