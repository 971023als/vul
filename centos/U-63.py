#!/bin/python3

import os
import stat
import json

# ftpusers 파일 경로 설정
ftpusers_file = "/etc/vsftpd/ftpusers"

# 결과 저장을 위한 딕셔너리
results = {
    "분류": "서비스 관리",
    "코드": "U-63",
    "위험도": "상",
    "진단 항목": "ftpusers 파일 소유자 및 권한 설정",
    "진단 결과": "",
    "현황": "",
    "대응방안": ""
}

# ftpusers 파일 존재 여부 및 소유자, 권한 검사
if os.path.exists(ftpusers_file):
    file_stat = os.stat(ftpusers_file)
    owner_uid = file_stat.st_uid
    file_mode = file_stat.st_mode

    # 파일 소유자가 root인지 확인
    if owner_uid == 0:
        owner_status = "OK"
        owner_info = "ftpusers 파일의 소유자가 root입니다."
    else:
        owner_status = "WARNING"
        owner_info = "ftpusers 파일의 소유자가 root가 아닙니다."

    # 파일 권한이 640 이하인지 확인
    if stat.S_IMODE(file_mode) <= 0o640:
        permission_status = "OK"
        permission_info = "ftpusers 파일의 권한이 640 이하입니다."
    else:
        permission_status = "WARNING"
        permission_info = "ftpusers 파일의 권한이 640을 초과합니다."

    results["진단 결과"] = "취약" if "WARNING" in [owner_status, permission_status] else "양호"
    results["현황"] = f"{owner_info} {permission_info}"
    results["대응방안"] = "ftpusers 파일의 소유자를 root로 설정하고, 권한을 640 이하로 설정하세요."
else:
    results["진단 결과"] = "정보 부족"
    results["현황"] = "ftpusers 파일이 존재하지 않습니다."
    results["대응방안"] = "ftp 서비스 사용 시, ftpusers 파일을 생성하고 적절한 소유자 및 권한을 설정하세요."

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
