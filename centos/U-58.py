#!/usr/bin/env python3
import json
import subprocess
from pathlib import Path

# 결과를 저장할 딕셔너리
results = {
    "U-58": {
        "title": "홈 디렉터리로 지정한 디렉터리의 존재 관리",
        "status": "",
        "description": {
            "good": "홈 디렉터리가 존재하지 않는 계정이 발견되지 않는 경우",
            "bad": "홈 디렉터리가 존재하지 않는 계정이 발견된 경우"
        },
        "details": []
    }
}

def check_home_directory_existence():
    with open("/etc/passwd", "r") as passwd_file:
        for line in passwd_file:
            fields = line.strip().split(":")
            if len(fields) >= 6:
                account, home_directory = fields[0], fields[5]
                if not Path(home_directory).exists():
                    results["U-58"]["details"].append(f"계정 {account}의 홈 디렉터리 {home_directory}가 존재하지 않습니다.")
                    results["U-58"]["status"] = "취약"
                else:
                    results["U-58"]["details"].append(f"계정 {account}의 홈 디렉터리 {home_directory}가 존재합니다.")

# 결과 확인 로직이 홈 디렉터리 존재 여부만 확인하므로, 모든 계정에 대한 검증 후 "양호" 상태 결정이 필요한 경우 로직 수정 필요
check_home_directory_existence()

# 결과 파일에 JSON 형태로 저장
result_file = 'home_directory_existence_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
