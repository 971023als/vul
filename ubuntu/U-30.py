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

def check_sendmail_version():
    """
    Sendmail 버전을 확인합니다. (시뮬레이션)
    """
    # 여기에 실제 Sendmail 버전 확인 로직 구현
    return "시뮬레이션된 버전 정보"  # 예시 반환값

# Sendmail 서비스 상태 확인
sendmail_active = check_sendmail_status()

# Sendmail 버전 확인 (시뮬레이션)
sendmail_version = check_sendmail_version()

diagnostic_item = "Sendmail 버전 점검"
if sendmail_active:
    status = "취약"
    situation = "Sendmail 데몬이 활성화되어 있는 상태"
    countermeasure = "Sendmail 데몬 비활성화 및 최신 버전으로 업데이트"
else:
    status = "양호"
    situation = "Sendmail 데몬이 비활성화되어 있는 상태"
    countermeasure = "Sendmail 데몬 유지 및 최신 버전으로 업데이트 확인"

results.append({
    "분류": "서비스 관리",
    "코드": "U-30",
    "위험도": "상",
    "진단 항목": diagnostic_item,
    "진단 결과": status,
    "현황": situation,
    "대응방안": countermeasure
})

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))

