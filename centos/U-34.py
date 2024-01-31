#!/bin/python3

import subprocess
import json

# 결과 저장을 위한 리스트
results = []

def check_dns_service_status():
    """
    DNS 서비스(named 프로세스)의 실행 상태를 확인합니다.
    """
    try:
        output = subprocess.check_output("ps -ef | grep named | grep -v grep", shell=True, stderr=subprocess.STDOUT)
        if output:
            return True  # 실행 중
        else:
            return False  # 실행되지 않음
    except subprocess.CalledProcessError:
        return False  # 프로세스가 없음

# DNS 서비스 실행 상태 확인
dns_service_active = check_dns_service_status()

# DNS Zone Transfer 설정 점검 (시뮬레이션)
# 실제 환경에서는 DNS 서버의 구성 파일을 분석하는 로직이 필요합니다.
zone_transfer_restriction_set = False  # 이 값은 실제 설정을 확인하여 결정해야 합니다.

diagnostic_item = "DNS Zone Transfer 설정"
if dns_service_active and not zone_transfer_restriction_set:
    status = "취약"
    situation = "DNS(named) 데몬이 활성화되어 있으며 Zone Transfer를 모든 사용자에게 허용한 상태"
    countermeasure = "Zone Transfer를 허가된 사용자에게만 허용하도록 설정"
else:
    status = "양호"
    situation = "DNS 서비스 미사용 또는, Zone Transfer를 허가된 사용자에게만 허용한 상태"
    countermeasure = "Zone Transfer 설정 유지 및 정기적 검토"

results.append({
    "분류": "서비스 관리",
    "코드": "U-34",
    "위험도": "상",
    "진단 항목": diagnostic_item,
    "진단 결과": status,
    "현황": situation,
    "대응방안": countermeasure
})

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
