#!/bin/python3

import os
import json

# 결과를 저장할 리스트 초기화
results = []

# 파일 내용 검사 함수
def check_file_contents(file_path):
    try:
        with open(file_path, 'r') as file:
            lines = file.readlines()
            # 빈 줄과 주석을 제외한 내용이 있는지 확인
            content = [line.strip() for line in lines if line.strip() and not line.startswith("#")]
            return bool(content)
    except FileNotFoundError:
        return False

# /etc/hosts.allow 파일 검사
hosts_allow_exists = check_file_contents("/etc/hosts.allow")
# /etc/hosts.deny 파일 검사
hosts_deny_exists = check_file_contents("/etc/hosts.deny")

# 진단 결과 판단
if hosts_allow_exists and hosts_deny_exists:
    diagnosis_result = "양호"
    status = "/etc/hosts.deny 파일에 ALL Deny 설정 후 /etc/hosts.allow 파일에 접근을 허용할 특정 호스트를 등록한 경우"
else:
    diagnosis_result = "취약"
    status = "/etc/hosts.deny 파일에 ALL Deny 설정 후 /etc/hosts.allow 파일에 접근을 허용할 특정 호스트를 등록하지 않은 경우"

# 결과 추가
results.append({
    "분류": "네트워크 접근 제어",
    "코드": "U-18",
    "위험도": "상",
    "진단 항목": "접속 IP 및 포트 제한",
    "진단 결과": diagnosis_result,
    "현황": status,
    "대응방안": "/etc/hosts.deny 파일에 ALL Deny 설정 후 /etc/hosts.allow 파일에 접근을 허용할 특정 호스트를 등록"
})

# JSON 형태로 결과 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
