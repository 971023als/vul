#!/bin/python3

import subprocess
import json

# /etc/passwd 파일에서 사용자 계정과 홈 디렉터리 정보 추출
try:
    accounts_info = subprocess.check_output("awk -F ':' '{print $1 \":\" $6}' /etc/passwd", shell=True, text=True)
except subprocess.CalledProcessError as e:
    print(f"Error reading /etc/passwd: {str(e)}")
    exit()

# 결과 저장을 위한 리스트
missing_home_directories = []

# 각 계정의 홈 디렉터리 존재 여부 점검
for line in accounts_info.strip().split('\n'):
    account, home_directory = line.split(':')
    if not home_directory or not subprocess.call(['ls', home_directory], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL) == 0:
        missing_home_directories.append(account)

# 결과 요약
summary = {
    "분류": "서비스 관리",
    "코드": "U-58",
    "위험도": "상",
    "진단 항목": "홈 디렉터리로 지정한 디렉터리의 존재 관리",
    "진단 결과": "취약" if missing_home_directories else "양호",
    "현황": f"홈 디렉터리가 존재하지 않는 계정: {', '.join(missing_home_directories)}" if missing_home_directories else "모든 계정에 홈 디렉터리가 존재합니다.",
    "대응방안": "홈 디렉터리가 없는 계정을 검토하고 필요에 따라 생성하거나 계정을 제거하세요." if missing_home_directories else "현재 설정 유지"
}

# 결과 출력
print(json.dumps(summary, ensure_ascii=False, indent=4))
