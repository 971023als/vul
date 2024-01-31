#!/bin/python3

import subprocess
import re
import json

def check_ftp_account_shell():
    results = []
    ftp_shell = None

    # /etc/passwd에서 FTP 계정의 셸을 확인합니다.
    with open('/etc/passwd', 'r') as f:
        for line in f:
            if line.startswith('ftp:'):
                ftp_shell = line.strip().split(':')[-1]
                break

    # FTP 포트가 수신 중인지 확인합니다.
    try:
        netstat_output = subprocess.check_output(['netstat', '-tnlp'], stderr=subprocess.STDOUT).decode('utf-8')
        ftp_port_open = ":21 " in netstat_output
    except subprocess.CalledProcessError:
        ftp_port_open = False

    # 결과를 분석하여 추가합니다.
    if ftp_shell == '/bin/false':
        shell_status = "양호"
        action = "현재 상태 유지"
        result = "정상"
    else:
        shell_status = "취약"
        action = "FTP 계정의 셸을 /bin/false로 설정 권장"
        result = "경고"

    results.append({
        "분류": "사용자 계정",
        "코드": "U-62",
        "위험도": "높음" if shell_status == "취약" else "낮음",
        "진단 항목": "FTP 계정 shell 제한",
        "진단 결과": shell_status,
        "현황": f"FTP 계정의 셸 설정: {ftp_shell}",
        "대응방안": action,
        "결과": result
    })

    # FTP 포트 상태 추가 분석
    if ftp_port_open and shell_status == "양호":
        results.append({
            "분류": "네트워크 서비스",
            "코드": "U-62-1",
            "위험도": "낮음",
            "진단 항목": "FTP 포트 상태",
            "진단 결과": "양호",
            "현황": "FTP 포트(21)가 열려 있지만, 셸 제한이 적절히 설정됨",
            "대응방안": "현재 상태 유지",
            "결과": "정상"
        })
    elif ftp_port_open:
        results.append({
            "분류": "네트워크 서비스",
            "코드": "U-62-1",
            "위험도": "높음",
            "진단 항목": "FTP 포트 상태",
            "진단 결과": "취약",
            "현황": "FTP 포트(21)가 열려 있음",
            "대응방안": "FTP 포트 닫기 또는 셸 제한 설정 권장",
            "결과": "경고"
        })

    return results

def save_results_to_json(results, file_path):
    with open(file_path, 'w') as f:
        json.dump(results, f, ensure_ascii=False, indent=4)

def main():
    results = check_ftp_account_shell()
    save_results_to_json(results, "ftp_account_shell_check_result.json")
    print("FTP 계정의 셸 제한 점검 결과를 ftp_account_shell_check_result.json 파일에 저장하였습니다.")

if __name__ == "__main__":
    main()
