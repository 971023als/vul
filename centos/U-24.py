#!/bin/python3

import subprocess
import json

# 결과 리스트 초기화
results = []

def check_nfs_services():
    """
    NFS 서비스 데몬(nfsd, statd, lockd)이 실행 중인지 확인합니다.
    """
    try:
        # NFS 서비스 데몬이 실행 중인지 확인
        nfs_services = subprocess.check_output("ps -ef | egrep 'nfsd|statd|lockd' | grep -v grep", shell=True)
        
        # 결과가 비어 있지 않은 경우, NFS 서비스가 실행 중임
        if nfs_services:
            return True
        else:
            return False
    except subprocess.CalledProcessError:
        # 에러가 발생한 경우(일반적으로 프로세스가 없을 때)
        return False

# NFS 서비스 상태 확인
nfs_active = check_nfs_services()

if nfs_active:
    results.append({
        "분류": "서비스 관리",
        "코드": "U-24",
        "위험도": "상",
        "진단 항목": "NFS 서비스 비활성화",
        "진단 결과": "취약",
        "현황": "NFS 서비스가 활성화 되어 있는 상태",
        "대응방안": "NFS 서비스 비활성화"
    })
    print("WARN: NFS 서비스 데몬이 실행 중입니다.")
else:
    results.append({
        "분류": "서비스 관리",
        "코드": "U-24",
        "위험도": "상",
        "진단 항목": "NFS 서비스 비활성화",
        "진단 결과": "양호",
        "현황": "NFS 서비스가 비활성화 되어 있는 상태",
        "대응방안": "NFS 서비스 비활성화"
    })
    print("OK: NFS 서비스 데몬이 실행되고 있지 않습니다.")

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
