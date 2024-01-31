#!/bin/python3
 
import subprocess
import os
import json

# 결과 저장을 위한 리스트
results = []

# Apache 설정 파일 및 루트 디렉터리 경로 설정
httpd_conf_file = "/etc/httpd/conf/httpd.conf"
# 이 경로는 실제 Apache 설치 경로에 따라 조정해야 할 수 있습니다.
# 예시에서는 설정 파일 경로를 기반으로 합니다. 실제로는 DocumentRoot나 ServerRoot 지시어를 분석해야 합니다.

unwanted_items = ["manual", "samples", "docs"]

def check_apache_running():
    """
    Apache(httpd) 서비스의 실행 상태를 확인합니다.
    """
    try:
        subprocess.check_output("pgrep -x 'httpd'", shell=True)
        return True
    except subprocess.CalledProcessError:
        return False

def check_unwanted_items(root_path, items):
    """
    불필요한 항목들이 지정된 경로에 존재하는지 확인합니다.
    """
    found_items = []
    for item in items:
        item_path = os.path.join(root_path, item)
        if os.path.exists(item_path):
            found_items.append(item)
    return found_items

apache_running = check_apache_running()
if apache_running:
    info_message = "아파치가 실행 중입니다."
    found_unwanted_items = check_unwanted_items(httpd_conf_file, unwanted_items)
    if found_unwanted_items:
        status = "취약"
        situation = f"Apache 설치 디렉터리 내 불필요한 항목들({', '.join(found_unwanted_items)})이 존재합니다."
        countermeasure = "Apache 설치 디렉터리 내 불필요한 파일 및 디렉터리 제거"
    else:
        status = "양호"
        situation = "Apache 설치 디렉터리 내 불필요한 파일 및 디렉터리가 존재하지 않습니다."
        countermeasure = "현재 상태 유지"
else:
    info_message = "아파치가 실행되지 않습니다."
    status = "정보 부족"
    situation = "Apache 서비스가 실행되지 않아 불필요한 파일 및 디렉터리의 존재 여부를 확인할 수 없습니다."
    countermeasure = "Apache 서비스 실행 시 불필요한 파일 및 디렉터리 제거 고려"

results.append({
    "분류": "서비스 관리",
    "코드": "U-38",
    "위험도": "상",
    "진단 항목": "웹 서비스(Apache) 불필요한 파일 제거",
    "진단 결과": status,
    "현황": situation,
    "대응방안": countermeasure
})

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
