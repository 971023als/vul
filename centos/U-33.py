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

# DNS 보안 패치 관리 상태 점검 (시뮬레이션)
# 실제 환경에서는 DNS 버전 확인 및 최신 패치 적용 여부를 검증하는 로직이 필요합니다.
security_patch_managed = False  # 이 값은 실제 상태를 반영해야 합니다.

diagnostic_item = "DNS 보안 버전 패치"
if dns_service_active and not security_patch_managed:
    status = "취약"
    situation = "DNS(named) 데몬이 활성화되어 있으며 주기적으로 패치를 관리하고 있지 않은 상태"
    countermeasure = "DNS 서버의 보안 패치 주기적 관리 및 최신 상태 유지"
else:
    status = "양호"
    situation = "DNS 서비스를 사용하지 않거나 주기적으로 패치를 관리하고 있는 상태"
    countermeasure = "DNS 서버의 보안 패치 관리 지속"

results.append({
    "분류": "서비스 관리",
    "코드": "U-33",
    "위험도": "상",
    "진단 항목": diagnostic_item,
    "진단 결과": status,
    "현황": situation,
    "대응방안": countermeasure
})

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
