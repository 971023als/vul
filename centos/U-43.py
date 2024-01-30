#!/usr/bin/env python3
import json
import subprocess
from pathlib import Path

# 결과를 저장할 딕셔너리
results = {
    "U-43": {
        "title": "로그의 정기적 검토 및 보고",
        "status": "",
        "description": {
            "good": "로그 기록의 검토, 분석, 리포트 작성 및 보고 등이 정기적으로 이루어지는 경우",
            "bad": "로그 기록의 검토, 분석, 리포트 작성 및 보고 등이 정기적으로 이루어지지 않는 경우"
        },
        "details": []
    }
}

# 로그 파일 경로 설정
log_files = ["/var/log/utmp", "/var/log/wtmp", "/var/log/btmp"]

def check_log_files():
    for log_file in log_files:
        if not Path(log_file).exists():
            results["U-43"]["details"].append(f"{log_file} 파일이 존재하지 않습니다.")
            results["U-43"]["status"] = "취약"
        else:
            results["U-43"]["details"].append(f"{log_file} 파일이 존재합니다.")
            # 정기적 검토 및 보고에 대한 추가 검증 필요
            results["U-43"]["status"] = "양호"

check_log_files()

# 추가 로그 분석 로직은 여기에 구현될 수 있습니다. 예: 실패한 로그인 시도 분석 등

# 결과 파일에 JSON 형태로 저장
result_file = 'log_review_and_reporting_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
