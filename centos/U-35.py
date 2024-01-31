#!/bin/python3

import subprocess
import json

# 결과 저장을 위한 리스트
results = []

# Apache 구성 파일 경로 설정
config_file = "/etc/httpd/conf/httpd.conf"

def check_directory_listing():
    """
    Apache 구성 파일에서 디렉터리 리스팅 설정을 확인합니다.
    """
    try:
        # 구성 파일에서 'Options Indexes' 지시어를 검색
        output = subprocess.check_output(f"grep -E '^[ \t]*Options[ \t]+Indexes' {config_file}", shell=True, stderr=subprocess.STDOUT)
        if output:
            return True  # 디렉터리 리스팅이 활성화
        else:
            return False  # 디렉터리 리스팅이 비활성화
    except subprocess.CalledProcessError:
        return False  # 'Options Indexes' 지시어가 없음

# 디렉터리 리스팅 설정 확인
directory_listing_enabled = check_directory_listing()

diagnostic_item = "웹 서비스(Apache) 디렉터리 리스팅 제거"
if directory_listing_enabled:
    status = "취약"
    situation = "웹 디렉터리 내 설정된 Indexes 옵션이 활성화되어 있는 상태"
    countermeasure = "웹 디렉터리 내 설정된 Indexes 옵션을 비활성화"
else:
    status = "양호"
    situation = "웹 디렉터리 내 설정된 Indexes 옵션이 비활성화되어 있는 상태"
    countermeasure = "웹 디렉터리 내 설정된 Indexes 옵션 유지"

results.append({
    "분류": "서비스 관리",
    "코드": "U-35",
    "위험도": "상",
    "진단 항목": diagnostic_item,
    "진단 결과": status,
    "현황": situation,
    "대응방안": countermeasure
})

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
