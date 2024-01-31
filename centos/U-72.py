#!/bin/python3

import os
import json

# 로그 파일과 로그 구성 파일 위치 정의
log_files = [
    "/var/log/secure",
    "/var/log/messages",
    "/var/log/audit/audit.log",
    "/var/log/httpd/access_log",
    "/var/log/httpd/error_log"
]

conf_files = [
    "/etc/rsyslog.conf",
    "/etc/httpd/conf/httpd.conf",
    "/etc/audit/auditd.conf"
]

# 결과 저장을 위한 딕셔너리
results = {
    "분류": "서비스 관리",
    "코드": "U-72",
    "위험도": "상",
    "진단 항목": "정책에 따른 시스템 로깅 설정",
    "현황": [],
    "대응방안": "모든 필수 로그 파일과 로그 구성 파일이 존재하도록 설정하세요."
}

# 로그 파일 존재 여부 검사
for file in log_files:
    if os.path.exists(file):
        results["현황"].append(f"{file} 파일이 존재합니다.")
    else:
        results["현황"].append(f"{file} 파일이 존재하지 않습니다.")
        results["진단 결과"] = "취약"

# 로그 구성 파일 존재 여부 검사
for file in conf_files:
    if os.path.exists(file):
        results["현황"].append(f"{file} 구성 파일이 존재합니다.")
    else:
        results["현황"].append(f"{file} 구성 파일이 존재하지 않습니다.")
        results["진단 결과"] = "취약"

# 모든 필수 파일이 존재하는 경우 진단 결과를 양호로 설정
if "진단 결과" not in results:
    results["진단 결과"] = "양호"

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
