#!/bin/python3

import os
import stat
import json

# /etc/hosts.lpd 파일 경로
hosts_lpd_file = "/etc/hosts.lpd"

# 결과 저장을 위한 딕셔너리
results = {
    "분류": "서비스 관리",
    "코드": "U-55",
    "위험도": "상",
    "진단 항목": "hosts.lpd 파일 소유자 및 권한 설정",
    "진단 결과": "",
    "현황": "",
    "대응방안": ""
}

if os.path.exists(hosts_lpd_file):
    # 파일 소유자 확인
    file_stat = os.stat(hosts_lpd_file)
    owner_uid = file_stat.st_uid
    owner_gid = file_stat.st_gid
    file_mode = stat.S_IMODE(file_stat.st_mode)

    # root 소유 여부 확인
    if owner_uid == 0 and owner_gid == 0:
        owner_status = "OK"
        owner_info = "hosts.lpd의 소유자는 root입니다."
    else:
        owner_status = "WARNING"
        owner_info = "hosts.lpd의 소유자는 root가 아닙니다."

    # 파일 권한 확인
    if file_mode == 0o600:
        permission_status = "OK"
        permission_info = "hosts.lpd에 대한 권한이 600입니다."
    else:
        permission_status = "WARNING"
        permission_info = f"hosts.lpd에 대한 권한이 {file_mode:o}로 설정되어 있습니다. 600으로 설정해야 합니다."

    results["진단 결과"] = "취약" if "WARNING" in [owner_status, permission_status] else "양호"
    results["현황"] = f"{owner_info} {permission_info}"
    results["대응방안"] = "hosts.lpd 파일의 소유자를 root로 설정하고 권한을 600으로 설정하세요."
else:
    results["진단 결과"] = "정보 부족"
    results["현황"] = "hosts.lpd 파일이 존재하지 않습니다."
    results["대응방안"] = "필요한 경우 hosts.lpd 파일을 생성하고 적절한 소유자 및 권한을 설정하세요."

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
