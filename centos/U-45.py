#!/bin/python3

import grp
import os
import stat
import json

# 결과 저장을 위한 딕셔너리
results = {
    "분류": "서비스 관리",
    "코드": "U-45",
    "위험도": "상",
    "진단 항목": "root 계정 su 제한",
    "진단 결과": "",
    "현황": "",
    "대응방안": ""
}

# 휠 그룹 존재 여부 확인
try:
    grp.getgrnam('wheel')
    wheel_group_exists = True
except KeyError:
    wheel_group_exists = False

# /bin/su 파일의 그룹 소유 및 권한 검사
su_path = "/bin/su"
if os.path.exists(su_path):
    su_stat = os.stat(su_path)
    su_group = grp.getgrgid(su_stat.st_gid).gr_name
    su_permissions = stat.S_IMODE(su_stat.st_mode)
    # SUID 및 SGID 비트 설정 확인 (4750 in octal)
    is_correct_permission = su_permissions == 0o4750
else:
    su_group = None
    is_correct_permission = False

# 진단 결과 결정
if wheel_group_exists and su_group == "wheel" and is_correct_permission:
    results["진단 결과"] = "양호"
    results["현황"] = "su 명령어 사용이 wheel 그룹에 제한되어 있습니다."
    results["대응방안"] = "현재 설정 유지"
else:
    results["진단 결과"] = "취약"
    results["현황"] = "su 명령어 사용 제한 설정이 적절히 구성되지 않았습니다."
    results["대응방안"] = "su 명령어 사용을 wheel 그룹에만 제한하도록 설정"

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
