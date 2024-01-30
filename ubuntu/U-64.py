#!/usr/bin/env python3
import json
import subprocess
import glob
import os

# 결과를 저장할 딕셔너리
results = {
    "U-64": {
        "title": "ftpusers 파일 설정",
        "status": "",
        "description": {
            "good": "FTP 서비스가 비활성화 되어 있거나, 활성 시 root 계정 접속을 차단한 경우",
            "bad": "FTP 서비스가 활성화 되어 있고, root 계정 접속을 허용한 경우"
        },
        "details": []
    }
}

def check_ftp_service():
    # ftp 프로세스가 실행 중인지 확인
    try:
        ftp_process = subprocess.check_output(['ps', '-ef']).decode('utf-8')
        if "ftp" in ftp_process:
            results["U-64"]["status"] = "취약"
            results["U-64"]["details"].append("FTP 프로세스가 실행되고 있습니다.")
        else:
            results["U-64"]["details"].append("FTP 프로세스가 실행되고 있지 않습니다.")
    except subprocess.CalledProcessError:
        results["U-64"]["details"].append("FTP 서비스를 확인할 수 없습니다.")
    
    # /etc/ftp* 및 /etc/vsftpd* 파일 존재 여부 확인
    ftp_files = glob.glob('/etc/ftp*') + glob.glob('/etc/vsftpd*')
    if ftp_files:
        results["U-64"]["status"] = "취약"
        results["U-64"]["details"].append(f"/etc/ftp* 및 /etc/vsftpd* 파일이 존재합니다: {ftp_files}")
    else:
        results["U-64"]["details"].append("/etc/ftp* 및 /etc/vsftpd* 파일이 존재하지 않습니다.")
    
    # ftp 계정의 셸에 /bin/false가 있는지 확인
    try:
        with open('/etc/passwd', 'r') as f:
            passwd_content = f.read()
        if "ftp" in passwd_content:
            results["U-64"]["status"] = "취약"
            results["U-64"]["details"].append("/etc/passwd에서 FTP 사용자를 찾을 수 있음")
        else:
            results["U-64"]["details"].append("/etc/passwd에서 FTP 사용자를 찾을 수 없음")
    except FileNotFoundError:
        results["U-64"]["details"].append("/etc/passwd 파일을 찾을 수 없습니다.")

check_ftp_service()

# 최종 상태 결정
if "취약" not in results["U-64"]["status"]:
    results["U-64"]["status"] = "양호"

# 결과 파일에 JSON 형태로 저장
result_file = 'ftp_service_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
