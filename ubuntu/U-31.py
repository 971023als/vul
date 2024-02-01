#!/bin/python3

import subprocess
import json

# 결과 저장을 위한 리스트
results = []

def check_sendmail_status():
    """
    Sendmail 서비스의 실행 상태를 확인합니다.
    """
    try:
        output = subprocess.check_output("ps -ef | grep sendmail | grep -v grep", shell=True, stderr=subprocess.STDOUT)
        if output:
            return True  # 실행 중
        else:
            return False  # 실행되지 않음
    except subprocess.CalledProcessError:
        return False  # 프로세스가 없음

# Sendmail 서비스 실행 상태 확인
sendmail_active = check_sendmail_status()

# Sendmail 릴레이 제한 설정 점검 (시뮬레이션)
# 실제 환경에서는 Sendmail 설정 파일을 분석하는 로직이 필요합니다.
relay_restriction_set = False  # 이 값은 실제 설정을 확인하여 결정해야 합니다.

diagnostic_item = "스팸 메일 릴레이 제한"
if sendmail_active and not relay_restriction_set:
    status = "취약"
    situation = "sendmail 데몬이 활성화되어 있으며 릴레이 제한이 설정되어 있지 않은 상태"
    countermeasure = "sendmail 데몬에 대한 릴레이 제한 설정"
else:
    status = "양호"
    situation = "SMTP 서비스가 비활성화되어 있거나 릴레이 제한이 설정되어 있는 상태"
    countermeasure = "릴레이 제한 설정 유지 및 검토"

results.append({
    "분류": "서비스 관리",
    "코드": "U-31",
    "위험도": "상",
    "진단 항목": diagnostic_item,
    "진단 결과": status,
    "현황": situation,
    "대응방안": countermeasure
})

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
