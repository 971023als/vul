#!/bin/python3
import subprocess
import json

# 결과 저장을 위한 리스트
results = []

def check_automountd_service():
    """
    automountd 서비스가 실행 중인지 확인합니다.
    """
    try:
        # `automount` 프로세스의 존재 여부 확인
        status_output = subprocess.check_output("ps -ef | grep automount | grep -v grep", shell=True).decode('utf-8')
        
        # `automount` 프로세스의 상태 확인
        if "automount" in status_output:
            return True  # 실행 중
        else:
            return False  # 실행되지 않음
    except subprocess.CalledProcessError:
        # 프로세스가 없는 경우
        return False

# automountd 서비스 상태 확인
automountd_active = check_automountd_service()

if automountd_active:
    results.append({
        "분류": "서비스 관리",
        "코드": "U-26",
        "위험도": "상",
        "진단 항목": "automountd 제거",
        "진단 결과": "취약",
        "현황": "OS는 로컬 디스크를 마운트하여 사용 중에 있으며, automount 데몬은 활성화되어 있어서 불안전한 상태",
        "대응방안": "automountd 제거"
    })
    print("WARN: Automount 서비스가 실행 중입니다.")
else:
    results.append({
        "분류": "서비스 관리",
        "코드": "U-26",
        "위험도": "상",
        "진단 항목": "automountd 제거",
        "진단 결과": "양호",
        "현황": "OS는 로컬 디스크를 마운트하여 사용 중에 있으며, automount 데몬은 활성화되어 있지 않아 안전한 상태",
        "대응방안": "automountd 제거"
    })
    print("OK: Automount 서비스가 실행되고 있지 않습니다.")

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
