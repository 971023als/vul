#!/bin/python3

import subprocess
import json

# 결과 저장을 위한 리스트
results = []

# NIS 관련 데몬 목록
nis_daemons = ["ypserv", "ypbind", "ypxfrd", "rpc.yppasswdd", "rpc.ypupdated"]

def check_nis_services():
    """
    시스템에서 NIS 관련 데몬이 실행 중인지 확인합니다.
    """
    active_services = []
    for daemon in nis_daemons:
        try:
            # 각 데몬에 대해 실행 중인 프로세스 확인
            output = subprocess.check_output(f"ps -ef | grep {daemon} | grep -v grep", shell=True, stderr=subprocess.STDOUT).decode('utf-8')
            if output:
                active_services.append(daemon)
        except subprocess.CalledProcessError:
            # 프로세스가 없으면 예외 발생
            continue
    return active_services

# NIS 서비스 상태 확인
active_nis_services = check_nis_services()

if active_nis_services:
    for service in active_nis_services:
        results.append({
            "분류": "서비스 관리",
            "코드": "U-28",
            "위험도": "상",
            "진단 항목": "NIS, NIS+ 점검",
            "진단 결과": "취약",
            "현황": f"{service} 관련 데몬이 활성화되어 있는 상태",
            "대응방안": "안전하지 않은 NIS, NIS+ 관련 데몬 비활성화"
        })
        print(f"WARN: {service}가 실행 중입니다.")
else:
    results.append({
        "분류": "서비스 관리",
        "코드": "U-28",
        "위험도": "상",
        "진단 항목": "NIS, NIS+ 점검",
        "진단 결과": "양호",
        "현황": "안전하지 않은 NIS, NIS+ 관련 데몬이 비활성화되어 있는 상태",
        "대응방안": "안전하지 않은 NIS, NIS+ 관련 데몬 비활성화"
    })
    print("OK: NIS 서비스가 비활성화되었습니다.")

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
