#!/bin/python3

import os
import json

# 설정 파일 및 기대 설정 정의
files = [
    "/etc/xinetd.d/rlogin",
    "/etc/xinetd.d/rsh",
    "/etc/xinetd.d/rexec"
]
expected_settings = [
    "socket_type= stream",
    "wait= no",
    "user= nobody",
    "log_on_success+= USERID",
    "log_on_failure+= USERID",
    "server= /usr/sdin/in.fingerd",  # 오타가 있어 보입니다. '/usr/sbin/in.fingerd'가 맞는 경로일 수 있습니다.
    "disable= yes"
]

# 결과 저장을 위한 리스트
results = []

# 파일 검사
for file in files:
    print(f"파일 확인 중: {file}")
    if not os.path.isfile(file):
        print(f"{file} 파일이 없습니다.")
        continue
    
    with open(file) as f:
        content = f.read()
        
    # 모든 설정이 올바르게 적용되었는지 확인
    all_settings_correct = True
    for setting in expected_settings:
        if setting not in content:
            print(f"{file} 파일에서 '{setting}'을 올바르게 설정하지 않았습니다.")
            all_settings_correct = False
        else:
            print(f"'{setting}'이 올바르게 설정되었습니다.")
    
    # 결과 추가
    if all_settings_correct:
        result_status = "양호"
    else:
        result_status = "취약"
    
    results.append({
        "분류": "서비스 관리",
        "코드": "U-21",
        "위험도": "상",
        "진단 항목": "r 계열 서비스 비활성화",
        "진단 결과": result_status,
        "현황": f"r 계열 서비스 {result_status} 되어 있는 경우",
        "대응방안": "r 계열 서비스 비활성화"
    })

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
