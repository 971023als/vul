#!/bin/python3

import subprocess
import json

def check_ftp_service():
    # FTP 서비스 상태 확인
    try:
        service_status = subprocess.check_output(["systemctl", "status", "vsftpd"], text=True)
        if "active (running)" in service_status:
            return "active"
    except subprocess.CalledProcessError:
        pass

    # FTP 포트 확인
    try:
        netstat_output = subprocess.check_output(["netstat", "-tnlp"], text=True)
        if ":21 " in netstat_output:
            return "active"
    except subprocess.CalledProcessError:
        pass

    return "inactive"

# /etc/passwd에서 FTP 사용자 계정 존재 여부 확인
def check_ftp_account():
    with open("/etc/passwd", "r") as passwd_file:
        for line in passwd_file:
            if line.startswith("ftp:"):
                return True
    return False

# 결과 저장을 위한 딕셔너리
results = {
    "분류": "서비스 관리",
    "코드": "U-61",
    "위험도": "상",
    "진단 항목": "ftp 서비스 확인",
    "진단 결과": "",
    "현황": "",
    "대응방안": ""
}

ftp_service_status = check_ftp_service()
ftp_account_exists = check_ftp_account()

if ftp_service_status == "active" or ftp_account_exists:
    results["진단 결과"] = "취약"
    results["현황"] = "FTP 서비스가 활성화 되어 있거나 FTP 계정이 존재합니다."
    results["대응방안"] = "FTP 서비스를 비활성화 하고, 필요하지 않은 FTP 계정을 제거하세요."
else:
    results["진단 결과"] = "양호"
    results["현황"] = "FTP 서비스가 비활성화 되어 있고, FTP 계정이 존재하지 않습니다."
    results["대응방안"] = "현재 설정 유지"

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
