#!/bin/python3

import subprocess
import json

# 결과 저장을 위한 리스트
results = []

def check_apache_process():
    """
    Apache(httpd) 데몬의 실행 상태와 권한을 확인합니다.
    """
    try:
        httpd_pids = subprocess.check_output("pgrep -x 'httpd'", shell=True, text=True).strip().split('\n')
        if httpd_pids:
            httpd_user = subprocess.check_output(f"ps -o user= -p {httpd_pids[0]}", shell=True, text=True).strip()
            httpd_group = subprocess.check_output(f"ps -o group= -p {httpd_pids[0]}", shell=True, text=True).strip()
            return True, httpd_user, httpd_group
        else:
            return False, '', ''
    except subprocess.CalledProcessError:
        return False, '', ''

apache_running, apache_user, apache_group = check_apache_process()

diagnostic_item = "웹 서비스(Apache) 프로세스 권한 제한"
if apache_running:
    if apache_user == "root" or apache_group == "root":
        status = "취약"
        situation = "Apache 데몬(httpd)이 root 권한으로 실행되고 있습니다"
        countermeasure = "Apache 데몬(httpd)을 root 권한이 아닌 다른 계정으로 구동"
    else:
        status = "양호"
        situation = f"Apache 데몬(httpd)이 root 권한이 아닌 {apache_user} 계정으로 구동중인 상태"
        countermeasure = "Apache 데몬(httpd)의 권한 제한 설정 유지"
else:
    status = "양호"
    situation = "Apache 데몬(httpd)이 실행되고 있지 않습니다"
    countermeasure = "필요 시 Apache 데몬 구동 및 권한 제한 설정 적용"

results.append({
    "분류": "서비스 관리",
    "코드": "U-36",
    "위험도": "상",
    "진단 항목": diagnostic_item,
    "진단 결과": status,
    "현황": situation,
    "대응방안": countermeasure
})

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))

 
