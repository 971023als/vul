#!/bin/python3

import subprocess
import json

# 결과 저장을 위한 리스트
results = []

# Apache 구성 파일 경로 설정
config_file = "/etc/httpd/conf/httpd.conf"

def check_file_transfer_restrictions():
    """
    Apache 구성 파일에서 파일 전송 제한 설정을 확인합니다.
    """
    restrictions = {
        "LimitRequestBody": False,
        "LimitXMLRequestBody": False,
        "LimitUploadSize": False  # 주의: LimitUploadSize는 표준 Apache 지시어가 아닙니다.
    }
    try:
        with open(config_file, 'r') as file:
            for line in file:
                for key in restrictions.keys():
                    if key in line and not line.strip().startswith("#"):
                        restrictions[key] = True
        return restrictions
    except FileNotFoundError:
        return None  # 구성 파일을 찾을 수 없음

# 파일 전송 제한 설정 확인
file_transfer_restrictions = check_file_transfer_restrictions()

diagnostic_item = "웹 서비스(Apache) 파일 업로드 및 다운로드 제한"
if file_transfer_restrictions:
    if all(file_transfer_restrictions.values()):
        status = "양호"
        situation = "Apache에서 파일 업로드 및 다운로드가 적절히 제한됩니다."
        countermeasure = "현재 설정 유지"
    else:
        status = "취약"
        situation = "Apache에서 파일 업로드 및 다운로드 제한 설정이 충분하지 않습니다."
        countermeasure = "LimitRequestBody, LimitXMLRequestBody 설정 적용 및 확인"
else:
    status = "정보 부족"
    situation = f"{config_file} 파일을 찾을 수 없습니다."
    countermeasure = "Apache 구성 파일 위치 확인 및 필요한 설정 적용"

results.append({
    "분류": "서비스 관리",
    "코드": "U-40",
    "위험도": "상",
    "진단 항목": diagnostic_item,
    "진단 결과": status,
    "현황": situation,
    "대응방안": countermeasure
})

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
