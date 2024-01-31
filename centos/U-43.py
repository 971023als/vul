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

# 로그 파일의 경로 정의
log_files = {
    "utmp": "/var/log/utmp",
    "wtmp": "/var/log/wtmp",
    "btmp": "/var/log/btmp",
    "sulog": "/var/log/sulog",
    "xferlog": "/var/log/xferlog"
}

def check_log_files():
    for key, log_file in log_files.items():
        if not Path(log_file).exists():
            results["U-43"]["details"].append(f"{log_file} 파일이 존재하지 않습니다.")
        else:
            if key in ['utmp', 'wtmp', 'btmp']:
                # 'last' 명령어로 로그 정보 검토
                try:
                    last_output = subprocess.check_output(['last', '-f', log_file], text=True)
                    results["U-43"]["details"].append(f"{key} 로그 정보:\n" + last_output.strip())
                except subprocess.CalledProcessError as e:
                    results["U-43"]["details"].append(f"{key} 로그 정보 검토 중 오류 발생: {e}")
            elif key == 'sulog':
                # sulog 파일 분석 로직 구현
                pass  # 실제 구현 필요
            elif key == 'xferlog':
                # xferlog 파일 분석 로직 구현
                pass  # 실제 구현 필요

check_log_files()

# 결과 파일에 JSON 형태로 저장
result_file = 'log_review_and_reporting_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
