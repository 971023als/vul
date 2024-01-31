#!/bin/python3

import subprocess
import datetime
import json

# 결과 저장을 위한 리스트
results = []

# 현재 날짜 설정
current_date = datetime.datetime.now().strftime('%Y-%m-%d')

# 패치 로그 파일 경로
patch_log_file = "/var/log/patch.log"

def check_patch_installation(log_file, check_date):
    """
    지정된 로그 파일에서 주어진 날짜에 설치된 패치의 존재 여부를 확인합니다.
    """
    try:
        with open(log_file, 'r') as file:
            for line in file:
                if f"Patches installed on {check_date}" in line:
                    return True
            return False
    except FileNotFoundError:
        return None

# 패치 설치 상태 확인
patch_installed = check_patch_installation(patch_log_file, current_date)

diagnostic_item = "최신 보안패치 및 벤더 권고사항 적용"
if patch_installed is True:
    status = "양호"
    situation = f"'{current_date}에 설치된 패치' 행이 {patch_log_file}에 있습니다."
    countermeasure = "패치 관리 정책 유지 및 주기적인 패치 적용 계속하기"
elif patch_installed is False:
    status = "취약"
    situation = f"'{current_date}에 설치된 패치' 행이 {patch_log_file}에 없습니다."
    countermeasure = "패치 적용 정책 수립 및 주기적으로 패치 관리하기"
else:
    status = "정보 부족"
    situation = f"{patch_log_file} 파일을 찾을 수 없습니다."
    countermeasure = "패치 로그 파일 위치 확인 및 필요한 패치 적용하기"

results.append({
    "분류": "서비스 관리",
    "코드": "U-42",
    "위험도": "상",
    "진단 항목": diagnostic_item,
    "진단 결과": status,
    "현황": situation,
    "대응방안": countermeasure
})

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
