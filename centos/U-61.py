#!/bin/python3

import subprocess
import json

def check_ftp_service():
    results = []
    # FTP 서비스 상태를 확인합니다.
    try:
        ftp_status = subprocess.check_output(['systemctl', 'status', 'vsftpd'], stderr=subprocess.STDOUT).decode('utf-8')
        ftp_active = "active (running)" in ftp_status
        if ftp_active:
            result = {
                "분류": "네트워크 서비스",
                "코드": "U-61",
                "위험도": "높음",
                "진단 항목": "FTP 서비스 확인",
                "진단 결과": "취약",
                "현황": "FTP 서비스가 활성화 되어 있습니다.",
                "대응방안": "FTP 서비스 비활성화 권장",
                "결과": "경고"
            }
            print("경고: FTP 서비스가 활성화 되어 있습니다.")
        else:
            result = {
                "분류": "네트워크 서비스",
                "코드": "U-61",
                "위험도": "낮음",
                "진단 항목": "FTP 서비스 확인",
                "진단 결과": "양호",
                "현황": "FTP 서비스가 비활성화 되어 있습니다.",
                "대응방안": "현재 상태 유지",
                "결과": "정상"
            }
            print("OK: FTP 서비스가 비활성화 되어 있습니다.")
    except subprocess.CalledProcessError:
        result = {
            "분류": "네트워크 서비스",
            "코드": "U-61",
            "위험도": "낮음",
            "진단 항목": "FTP 서비스 확인",
            "진단 결과": "양호",
            "현황": "FTP 서비스가 설치되지 않았거나 확인할 수 없습니다.",
            "대응방안": "필요에 따라 FTP 서비스 설치 및 구성",
            "결과": "정상"
        }
        print("정보: FTP 서비스가 설치되지 않았거나 확인할 수 없습니다.")

    results.append(result)

    # FTP 포트가 수신 중인지 확인합니다.
    try:
        netstat_output = subprocess.check_output(['netstat', '-tnlp'], stderr=subprocess.STDOUT).decode('utf-8')
        if ":21 " in netstat_output:
            print("경고: FTP 포트(21)가 열려 있습니다.")
        else:
            print("OK: FTP 포트(21)가 열려 있지 않습니다.")
    except subprocess.CalledProcessError:
        print("정보: netstat 명령을 실행할 수 없습니다.")

    return results

def save_results_to_json(results, file_path):
    with open(file_path, 'w') as f:
        json.dump(results, f, ensure_ascii=False, indent=4)

def main():
    results = check_ftp_service()
    save_results_to_json(results, "ftp_service_check_result.json")
    print("FTP 서비스 점검 결과를 ftp_service_check_result.json 파일에 저장하였습니다.")

if __name__ == "__main__":
    main()
