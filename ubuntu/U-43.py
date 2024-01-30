import os
import subprocess
import json

# 결과를 저장할 딕셔너리
results = {
    "U-43": {
        "title": "로그의 정기적 검토 및 보고",
        "status": "",
        "description": {
            "good": "로그 기록의 검토, 분석, 리포트 작성 및 보고 등이 정기적으로 이루어지는 경우",
            "bad": "로그 기록의 검토, 분석, 리포트 작성 및 보고 등이 정기적으로 이루어지지 않는 경우",
        },
        "log_files": {}
    }
}

log_files = ["/var/log/utmp", "/var/log/wtmp", "/var/log/btmp", "/var/log/sulog", "/var/log/xferlog"]

def check_log_files_existence():
    for log_file in log_files:
        if os.path.exists(log_file):
            results["log_files"][log_file] = "존재함"
        else:
            results["log_files"][log_file] = "존재하지 않음"
            results["status"] = "취약"

    if not results["status"]:
        results["status"] = "양호"
        results["description"]["good"] += " 모든 필수 로그 파일이 존재합니다."

# 검사 수행
check_log_files_existence()

# 결과를 JSON 파일로 저장
with open('result.json', 'w', encoding='utf-8') as f:
    json.dump(results, f, ensure_ascii=False, indent=4)

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
