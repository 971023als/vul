#!/usr/bin/env python3
import json
import subprocess

# 결과를 저장할 딕셔너리
results = {
    "U-19": {
        "title": "Finger 서비스 비활성화",
        "status": "",
        "description": {
            "good": "Finger 서비스가 비활성화 되어 있는 경우",
            "bad": "Finger 서비스가 활성화 되어 있는 경우"
        },
        "details": []
    }
}

def check_finger_service():
    try:
        # Finger 서비스가 실행 중인지 확인
        process = subprocess.run(["pgrep", "-x", "fingerd"], capture_output=True, text=True)
        if process.returncode == 0:
            results["U-19"]["status"] = "취약"
            results["U-19"]["details"].append("Finger 서비스가 실행되고 있습니다.")
        else:
            results["U-19"]["status"] = "양호"
            results["U-19"]["details"].append("Finger 서비스가 실행되고 있지 않습니다.")
    except Exception as e:
        results["U-19"]["details"].append(f"Finger 서비스 검사 중 오류 발생: {e}")
        results["U-19"]["status"] = "정보"

check_finger_service()

# 결과 파일에 JSON 형태로 저장
result_file = 'finger_service_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
