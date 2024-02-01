#!/usr/bin/python3
import subprocess
import json
import re

def check_ftp_service():
    results = {
        "분류": "시스템 설정",
        "코드": "U-61",
        "위험도": "상",
        "진단 항목": "ftp 서비스 확인",
        "진단 결과": "",
        "현황": [],
        "대응방안": "[양호]: FTP 서비스가 비활성화 되어 있는 경우\n[취약]: FTP 서비스가 활성화 되어 있는 경우"
    }

    # FTP 계정의 존재와 셸 설정 확인
    try:
        with open("/etc/passwd", "r") as passwd_file:
            ftp_entry = [line for line in passwd_file if line.startswith("ftp:")]
            if ftp_entry:
                ftp_shell = ftp_entry[0].strip().split(":")[-1]
                if ftp_shell == "/bin/false":
                    results["현황"].append("FTP 계정의 셸이 /bin/false로 설정되었습니다.")
                else:
                    results["진단 결과"] = "취약"
                    results["현황"].append("FTP 계정의 셸이 /bin/false로 설정되지 않았습니다.")
            else:
                results["현황"].append("FTP 계정이 존재하지 않습니다.")
    except FileNotFoundError:
        results["현황"].append("/etc/passwd 파일을 찾을 수 없습니다.")

    # FTP 포트(21) 사용 여부 확인
    try:
        ss_output = subprocess.check_output(["ss", "-tnlp"], text=True)
        if re.search(r':21', ss_output):
            results["진단 결과"] = "취약"
            results["현황"].append("FTP 포트(21)가 열려 있습니다.")
        else:
            if "취약" not in results["진단 결과"]:
                results["진단 결과"] = "양호"
            results["현황"].append("FTP 포트(21)가 열려 있지 않습니다.")
    except subprocess.CalledProcessError:
        results["현황"].append("FTP 포트 상태 확인 중 오류 발생.")

    return results

def main():
    results = check_ftp_service()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
