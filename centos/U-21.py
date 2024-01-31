#!/bin/python3

import json
import os

# 결과를 저장할 리스트 초기화
results = []

# r 계열 서비스 파일 목록과 예상 설정
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
    "server= /usr/sbin/in.fingerd",
    "disable= yes"
]

# 파일과 설정 검사 함수
def check_r_services(files, expected_settings):
    for file_path in files:
        if not os.path.isfile(file_path):
            results.append({
                "파일": file_path,
                "상태": "정보",
                "메시지": f"{file_path} 파일이 없습니다.",
                "대응방안": "r 계열 서비스 비활성화"
            })
        else:
            with open(file_path, 'r') as file:
                content = file.read()
                for setting in expected_settings:
                    if setting not in content:
                        results.append({
                            "파일": file_path,
                            "상태": "취약",
                            "메시지": f"{file_path} 파일에서 '{setting}'을 올바르게 설정하지 않았습니다.",
                            "대응방안": "r 계열 서비스 비활성화"
                        })
                        break
                else:
                    results.append({
                        "파일": file_path,
                        "상태": "양호",
                        "메시지": f"{file_path}의 모든 예상 설정이 올바르게 구성되었습니다.",
                        "대응방안": "r 계열 서비스 비활성화"
                    })

# r 계열 서비스 파일과 설정 검사 실행
check_r_services(files, expected_settings)

# JSON 형태로 결과 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
