#!/bin/python3

import os
import stat
import json

# NFS 설정 파일 경로
filename = "/etc/exports"

# 결과 저장을 위한 딕셔너리
results = {
    "분류": "서비스 관리",
    "코드": "U-69",
    "위험도": "상",
    "진단 항목": "NFS 설정파일 접근권한",
    "진단 결과": "",
    "현황": "",
    "대응방안": ""
}

# 파일 존재 여부 및 소유자, 권한 검사
if os.path.exists(filename):
    file_stat = os.stat(filename)
    owner_uid = file_stat.st_uid
    file_permission = oct(file_stat.st_mode)[-3:]

    if owner_uid == 0 and int(file_permission) <= 644:
        results["진단 결과"] = "양호"
        results["현황"] = f"{filename}의 소유자가 root이고, 권한이 644 이하입니다."
    else:
        results["진단 결과"] = "취약"
        results["현황"] = f"{filename}의 소유자가 root가 아니거나, 권한이 644를 초과합니다."
else:
    results["진단 결과"] = "정보 부족"
    results["현황"] = f"{filename} 파일이 존재하지 않습니다."

# 대응방안 설정
results["대응방안"] = f"{filename}의 소유자를 root로 설정하고, 권한을 644 이하로 조정하세요."

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
