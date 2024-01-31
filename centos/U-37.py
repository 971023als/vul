#!/bin/python3

import subprocess
import json

# 결과 저장을 위한 리스트
results = []

# Apache 구성 파일 경로 설정
httpd_conf_file = "/etc/httpd/conf/httpd.conf"
allow_override_option = "AllowOverride AuthConfig"

def check_directory_access_restriction():
    """
    Apache 구성 파일에서 상위 디렉터리 접근 제한 설정을 확인합니다.
    """
    try:
        with open(httpd_conf_file, 'r') as file:
            contents = file.read()
            if allow_override_option in contents:
                return True  # 설정이 존재
            else:
                return False  # 설정이 존재하지 않음
    except FileNotFoundError:
        return None  # 구성 파일을 찾을 수 없음

# 상위 디렉터리 접근 제한 설정 확인
access_restriction = check_directory_access_restriction()

diagnostic_item = "웹 서비스(Apache) 상위 디렉터리 접근 금지"
if access_restriction is True:
    status = "양호"
    situation = f"{httpd_conf_file}에서 {allow_override_option} 설정을 찾았습니다."
    countermeasure = "상위 디렉터리로의 접근을 제한하는 설정 유지"
elif access_restriction is False:
    status = "취약"
    situation = f"{httpd_conf_file}에서 {allow_override_option} 설정을 찾을 수 없습니다."
    countermeasure = "상위 디렉터리로의 접근을 제한하는 설정 적용"
else:
    status = "정보 부족"
    situation = f"{httpd_conf_file} 파일을 찾을 수 없습니다."
    countermeasure = f"{httpd_conf_file} 파일 위치 확인 및 접근 제한 설정 적용"

results.append({
    "분류": "서비스 관리",
    "코드": "U-37",
    "위험도": "상",
    "진단 항목": diagnostic_item,
    "진단 결과": status,
    "현황": situation,
    "대응방안": countermeasure
})

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
