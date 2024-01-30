#!/usr/bin/python3

import subprocess
import json

# 결과를 저장할 딕셔너리
results = {
    "U-19": {
        "title": "Finger 서비스 비활성화",
        "status": "",
        "description": {
            "good": "Finger 서비스가 비활성화 되어 있는 경우",
            "bad": "Finger 서비스가 활성화 되어 있는 경우",
        },
        "message": ""
    }
}

def check_finger_service():
    try:
        # Finger 서비스의 실행 여부 확인
        result = subprocess.run(["pgrep", "-x", "fingerd"], capture_output=True, text=True)
        if result.stdout:
            results["U-19"]["status"] = "취약"
            results["U-19"]["message"] = results["U-19"]["description"]["bad"]
        else:
            results["U-19"]["status"] = "양호"
            results["U-19"]["message"] = results["U-19"]["description"]["good"]
    except Exception as e:
        results["U-19"]["status"] = "오류"
        results["U-19"]["message"] = f"Finger 서비스 확인 중 오류 발생: {e}"

# 검사 수행
check_finger_service()

# 결과를 JSON 파일로 저장
with open('result.json', 'w', encoding='utf-8') as f:
    json.dump(results, f, ensure_ascii=False, indent=4)

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
