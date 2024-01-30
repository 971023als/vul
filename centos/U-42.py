#!/usr/bin/env python3
import json
import subprocess
from datetime import datetime

# 결과를 저장할 딕셔너리
results = {
    "U-42": {
        "title": "최신 보안패치 및 벤더 권고사항 적용",
        "status": "",
        "description": {
            "good": "패치 적용 정책을 수립하여 주기적으로 패치를 관리하고 있는 경우",
            "bad": "패치 적용 정책을 수립하지 않고 주기적으로 패치관리를 하지 않는 경우"
        },
        "details": []
    }
}

# 패치 로그 파일 경로 설정
patch_log_file = "/var/log/patch.log"
current_date = datetime.now().strftime('%Y-%m-%d')

def check_patch_installation():
    try:
        # 패치 로그 파일에서 현재 날짜에 해당하는 패치 설치 기록을 확인
        with open(patch_log_file, 'r') as file:
            if f"Patches installed on {current_date}" in file.read():
                results["U-42"]["status"] = "양호"
                results["U-42"]["details"].append(f"'{current_date}에 설치된 패치' 기록이 {patch_log_file}에 있습니다.")
            else:
                results["U-42"]["status"] = "취약"
                results["U-42"]["details"].append(f"'{current_date}에 설치된 패치' 기록이 {patch_log_file}에 없습니다.")
    except FileNotFoundError:
        results["U-42"]["details"].append(f"{patch_log_file} 파일을 찾을 수 없습니다.")
        results["U-42"]["status"] = "정보"

check_patch_installation()

# 결과 파일에 JSON 형태로 저장
result_file = 'security_patch_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
