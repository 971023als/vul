#!/bin/python3
import re
import json

# 결과 저장을 위한 리스트
results = []

def check_nfs_access_control():
    """
    /etc/exports 파일에서 'everyone' 그룹에 대한 제한 없는 접근을 확인합니다.
    """
    try:
        with open('/etc/exports', 'r') as file:
            contents = file.read()
            # 정규 표현식을 사용하여 'everyone'에 대한 제한 없는 접근이 있는지 확인
            if re.search(r'^[^#].*\severyone(?!.*no_root_squash)', contents, re.MULTILINE):
                return "WARN", "NFS는 '모두' 그룹에 대한 제한 없이 수출을 공유하고 있습니다"
            else:
                return "OK", "NFS는 '모두' 그룹에 대한 제한 없이 수출을 공유하지 않습니다."
    except FileNotFoundError:
        return "N/A", "/etc/exports 파일이 존재하지 않습니다."

status, message = check_nfs_access_control()

if status == "WARN":
    results.append({
        "분류": "서비스 관리",
        "코드": "U-25",
        "위험도": "상",
        "진단 항목": "NFS 접근 통제",
        "진단 결과": "취약",
        "현황": "NFS 서비스가 활성화 되어 있는 상태",
        "대응방안": "NFS 서비스 비활성화"
    })
else:
    results.append({
        "분류": "서비스 관리",
        "코드": "U-25",
        "위험도": "상",
        "진단 항목": "NFS 접근 통제",
        "진단 결과": "양호",
        "현황": "NFS 서비스가 비활성화 되어 있는 상태",
        "대응방안": "NFS 서비스 비활성화"
    })

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
