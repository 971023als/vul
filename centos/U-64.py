#!/bin/python3

import subprocess
import os
import json
import glob

def check_ftp_service():
    results = []

    # ftp 프로세스가 실행 중인지 확인합니다.
    try:
        ftp_process = subprocess.check_output(["pgrep", "-f", "ftp"], text=True).strip()
        if ftp_process:
            process_status = "경고: 프로세스가 실행되고 있습니다."
            process_result = "취약"
        else:
            process_status = "OK: 프로세스가 실행되고 있지 않습니다."
            process_result = "양호"
    except subprocess.CalledProcessError:
        process_status = "INFO: ftp 서비스를 확인할 수 없습니다."
        process_result = "정보"

    # /etc/ftp* 또는 /etc/vsftp* 파일이 있는지 확인합니다.
    ftp_files = glob.glob('/etc/ftp*') + glob.glob('/etc/vsftp*')
    if ftp_files:
        files_status = "경고: /etc/ftp* 및 /etc/vsftp* 파일이 존재합니다."
        files_result = "취약"
    else:
        files_status = "OK: /etc/ftp* 및 /etc/vsftp* 파일이 존재하지 않습니다."
        files_result = "양호"

    # /etc/passwd에서 ftp 계정의 셸에 /bin/false가 있는지 확인합니다.
    try:
        with open('/etc/passwd', 'r') as f:
            passwd_contents = f.read()
        if "ftp" in passwd_contents:
            user_status = "경고: /etc/passwd에서 사용자를 찾을 수 있음"
            user_result = "취약"
        else:
            user_status = "OK: /etc/passwd에서 사용자를 찾을 수 없음"
            user_result = "양호"
    except FileNotFoundError:
        user_status = "INFO: /etc/passwd 파일을 찾을 수 없습니다."
        user_result = "정보"

    results.append({
        "분류": "네트워크 서비스",
        "코드": "U-64",
        "위험도": "높음" if process_result == "취약" or files_result == "취약" or user_result == "취약" else "낮음",
        "진단 항목": "ftpusers 파일 설정",
        "진단 결과": ", ".join(filter(None, [process_result, files_result, user_result])),
        "현황": ", ".join(filter(None, [process_status, files_status, user_status])),
        "대응방안": "FTP 서비스 비활성화 및 불필요한 FTP 관련 파일 삭제, 필요 시 사용자 셸 설정 조정",
        "결과": "경고" if process_result == "취약" or files_result == "취약" or user_result == "취약" else "정상"
    })

    return results

def save_results_to_json(results, file_path):
    with open(file_path, 'w') as f:
        json.dump(results, f, ensure_ascii=False, indent=4)

def main():
    results = check_ftp_service()
    save_results_to_json(results, "ftp_service_config_check_result.json")
    print("FTP 서비스 설정 점검 결과를 ftp_service_config_check_result.json 파일에 저장하였습니다.")

if __name__ == "__main__":
    main()
