#!/bin/python3

import subprocess
import json

# 결과 저장을 위한 리스트
results = []

# 확인할 RPC 서비스 목록
services = [
    "rpc.cmsd", "rpc.ttdbserverd", "sadmin", "rusersd", "walld", "sprayd",
    "rstatd", "rpc.nisd", "rexd", "rpc.pcnfsd", "rpc.statd", "rpc.ypupdated",
    "rpc.requotad", "kcms_server", "cachefsd"
]

def check_rpc_service(service):
    """
    주어진 RPC 서비스의 상태를 확인합니다.
    """
    try:
        # systemctl을 사용하여 서비스 상태 확인
        subprocess.check_output(f"systemctl is-active {service}", shell=True, stderr=subprocess.STDOUT)
        # 서비스가 실행 중인 경우
        return True
    except subprocess.CalledProcessError:
        # 서비스가 비활성화되어 있거나 실행 중이지 않은 경우
        return False

# 각 RPC 서비스에 대해 확인
for service in services:
    if check_rpc_service(service):
        result_status = "취약"
        message = f"{service} 서비스가 활성"
    else:
        result_status = "양호"
        message = f"{service} 서비스가 활성화되지 않았습니다."
    
    results.append({
        "분류": "서비스 관리",
        "코드": "U-27",
        "위험도": "상",
        "진단 항목": "RPC 서비스 확인",
        "진단 결과": result_status,
        "현황": message,
        "대응방안": "RPC 서비스 중 NFS 등 불필요한 서비스 비활성화"
    })

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
