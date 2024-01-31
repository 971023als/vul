#!/bin/python3

import subprocess
import os
import json

# 결과 저장을 위한 딕셔너리
results = {
    "분류": "서비스 관리",
    "코드": "U-64",
    "위험도": "상",
    "진단 항목": "ftpusers 파일 설정",
    "진단 결과": "",
    "현황": "",
    "대응방안": ""
}

# FTP 서비스의 활성화 상태 확인
def check_ftp_service():
    try:
        output = subprocess.check_output(['ps', '-ef'], text=True)
        if 'ftp' in output:
            return True
    except Exception as e:
        return False
    return False

# ftpusers 파일 내 root 계정 접속 차단 여부 확인
def check_root_access():
    ftpusers_file = "/etc/ftpusers"
    if os.path.exists(ftpusers_file):
        with open(ftpusers_file, 'r') as file:
            for line in file:
                if 'root' in line.strip():
                    return True
    return False

ftp_service_active = check_ftp_service()
root_access_blocked = check_root_access()

if not ftp_service_active:
    results["진단 결과"] = "양호"
    results["현황"] = "FTP 서비스가 비활성화 되어 있습니다."
elif ftp_service_active and root_access_blocked:
    results["진단 결과"] = "양호"
    results["현황"] = "FTP 서비스가 활성화 되어 있으나, root 계정 접속이 차단되어 있습니다."
else:
    results["진단 결과"] = "취약"
    results["현황"] = "FTP 서비스가 활성화 되어 있고, root 계정 접속이 허용되어 있습니다."
    results["대응방안"] = "FTP 서비스를 비활성화 하거나, /etc/ftpusers 파일을 수정하여 root 계정 접속을 차단하세요."

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))

