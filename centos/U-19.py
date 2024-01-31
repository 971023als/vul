#!/bin/python3

import subprocess
import json

# 결과를 저장할 리스트 초기화
results = []

# finger 서비스 실행 여부 검사 함수
def check_finger_service():
    try:
        # "pgrep -x" 명령어를 사용하여 fingerd 프로세스 검사
        process = subprocess.run(["pgrep", "-x", "fingerd"], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        if process.returncode == 0:
            return "취약", "Finger 서비스가 실행되고 있습니다"
        else:
            return "양호", "Finger 서비스가 실행되고 있지 않습니다"
    except Exception as e:
        return "오류", str(e)

# finger 서비스 검사 실행
diagnosis_result, status_message = check_finger_service()

# 결과 추가
results.append({
    "분류": "서비스 관리",
    "코드": "U-19",
    "위험도": "상",
    "진단 항목": "finger 서비스 비활성화",
    "진단 결과": diagnosis_result,
    "현황": status_message,
    "대응방안": "Finger 서비스 비활성화"
})

# JSON 형태로 결과 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
