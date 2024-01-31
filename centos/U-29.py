#!/bin/python3

import subprocess
import json

# 결과 저장을 위한 리스트
results = []

# 확인할 서비스 목록
services = ["tftp", "talk", "ntalk"]

def check_service_status(service):
    """
    주어진 서비스의 활성화 여부를 확인합니다.
    """
    try:
        subprocess.check_output(f"systemctl is-enabled {service}", shell=True, stderr=subprocess.STDOUT)
        # 서비스가 활성화되어 있으면 True 반환
        return True
    except subprocess.CalledProcessError:
        # 서비스가 비활성화되어 있으면 False 반환
        return False

# 각 서비스의 상태 확인 및 결과 추가
for service in services:
    if check_service_status(service):
        results.append({
            "분류": "서비스 관리",
            "코드": "U-29",
            "위험도": "상",
            "진단 항목": f"{service} 서비스 비활성화",
            "진단 결과": "취약",
            "현황": f"{service} 데몬이 활성화되어 있는 상태",
            "대응방안": f"{service} 데몬 비활성화 및 xinetd(인터넷슈퍼데몬) 비활성화"
        })
    else:
        results.append({
            "분류": "서비스 관리",
            "코드": "U-29",
            "위험도": "상",
            "진단 항목": f"{service} 서비스 비활성화",
            "진단 결과": "양호",
            "현황": f"{service} 데몬이 비활성화되어 있고 xinetd(인터넷슈퍼데몬)에 존재하지 않는 상태",
            "대응방안": f"{service} 데몬 비활성화 및 xinetd(인터넷슈퍼데몬) 비활성화"
        })

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
