#!/usr/bin/python3
import subprocess
import os
import json

def check_ftp_service_and_root_access():
    results = {
        "분류": "시스템 설정",
        "코드": "U-64",
        "위험도": "상",
        "진단 항목": "ftpusers 파일 설정",
        "진단 결과": "",
        "현황": [],
        "대응방안": "[양호]: FTP 서비스가 비활성화 되어 있거나, 활성 시 root 계정 접속을 차단한 경우\n[취약]: FTP 서비스가 활성화 되어 있고, root 계정 접속을 허용한 경우"
    }

    # FTP 서비스의 상태를 확인합니다.
    try:
        ftp_process = subprocess.check_output(["pgrep", "-f", "ftp"], text=True).strip()
        if ftp_process:
            results["현황"].append("프로세스가 실행되고 있습니다.")
            results["진단 결과"] = "취약"
        else:
            results["현황"].append("프로세스가 실행되고 있지 않습니다.")
    except subprocess.CalledProcessError:
        results["현황"].append("프로세스가 실행되고 있지 않습니다.")

    # /etc/ftp* 및 /etc/vsftp* 파일의 존재를 확인합니다.
    ftp_files_exist = os.path.exists("/etc/ftp") or os.path.exists("/etc/vsftp")
    if ftp_files_exist:
        results["현황"].append("/etc/ftp* 또는 /etc/vsftp* 파일이 존재합니다.")
        results["진단 결과"] = "취약"
    else:
        results["현황"].append("/etc/ftp* 또는 /etc/vsftp* 파일이 존재하지 않습니다.")

    # ftp 계정의 셸 설정을 확인합니다.
    try:
        with open("/etc/passwd", "r") as passwd_file:
            for line in passwd_file:
                if line.startswith("ftp:"):
                    if "/bin/false" in line:
                        results["현황"].append("ftp 계정의 셸이 /bin/false로 설정되었습니다.")
                    else:
                        results["현황"].append("ftp 계정의 셸이 /bin/false로 설정되지 않았습니다.")
                        results["진단 결과"] = "취약"
                    break
    except FileNotFoundError:
        results["현황"].append("/etc/passwd 파일을 찾을 수 없습니다.")

    if "취약" not in results["진단 결과"]:
        results["진단 결과"] = "양호"

    return results

def main():
    results = check_ftp_service_and_root_access()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
