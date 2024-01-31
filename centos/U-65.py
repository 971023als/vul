#!/bin/python3

import subprocess
import os
import json

# 결과 저장을 위한 딕셔너리
results = {
    "분류": "서비스 관리",
    "코드": "U-65",
    "위험도": "상",
    "진단 항목": "at 파일 소유자 및 권한 설정",
    "진단 결과": "",
    "현황": "",
    "대응방안": ""
}

# at.allow 파일 경로
at_allow_file = "/etc/at.allow"

# at 명령 사용 가능 여부 확인
try:
    subprocess.check_output(["command", "-v", "at"], stderr=subprocess.STDOUT)
    at_command_available = True
except subprocess.CalledProcessError:
    at_command_available = False

# at.allow 파일 존재 여부 및 소유자, 권한 검사
if at_command_available and os.path.exists(at_allow_file):
    file_stat = os.stat(at_allow_file)
    owner_uid = file_stat.st_uid
    file_permissions = oct(file_stat.st_mode)[-3:]

    if owner_uid == 0 and int(file_permissions) <= 640:
        results["진단 결과"] = "양호"
        results["현황"] = f"{at_allow_file}의 소유자가 root이고, 권한이 640 이하입니다."
    else:
        results["진단 결과"] = "취약"
        results["현황"] = f"{at_allow_file}의 소유자 또는 권한 설정이 적절하지 않습니다."
    results["대응방안"] = f"{at_allow_file}의 소유자를 root로 설정하고, 권한을 640 이하로 조정하세요."
else:
    results["진단 결과"] = "정보 부족"
    results["현황"] = "at 명령이 사용 불가능하거나 at.allow 파일이 존재하지 않습니다."
    results["대응방안"] = "at 명령 사용 시, at.allow 파일을 생성하고 적절한 소유자 및 권한을 설정하세요."

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
