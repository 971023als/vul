#!/usr/bin/env python3
import json
import subprocess

# 결과를 저장할 딕셔너리
results = {
    "U-26": {
        "title": "automountd 제거",
        "status": "",
        "description": {
            "good": "automountd 서비스가 비활성화 되어있는 경우",
            "bad": "automountd 서비스가 활성화 되어있는 경우"
        },
        "details": []
    }
}

def check_automountd_service():
    try:
        # automount 서비스가 실행 중인지 확인
        process = subprocess.run(["pgrep", "-f", "automount"], capture_output=True, text=True)
        if process.returncode == 0:
            results["U-26"]["status"] = "취약"
            results["U-26"]["details"].append("Automount 서비스가 실행 중입니다.")
        else:
            results["U-26"]["status"] = "양호"
            results["U-26"]["details"].append("Automount 서비스가 실행되고 있지 않습니다.")
    except Exception as e:
        results["U-26"]["details"].append(f"Automount 서비스 검사 중 오류 발생: {e}")
        results["U-26"]["status"] = "정보"

check_automountd_service()

# 결과 파일에 JSON 형태로 저장
result_file = 'automountd_service_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
