#!/usr/bin/python3
import subprocess
import re
import json

def check_ftp_account_shell_restriction():
    results = {
        "분류": "시스템 설정",
        "코드": "U-62",
        "위험도": "상",
        "진단 항목": "ftp 계정 shell 제한",
        "진단 결과": "",
        "현황": [],
        "대응방안": "[양호]: ftp 계정에 /bin/false 쉘이 부여되어 있는 경우\n[취약]: ftp 계정에 /bin/false 쉘이 부여되지 않는 경우"
    }

    try:
        # /etc/passwd에서 FTP 계정의 셸을 확인합니다
        ftp_shell = subprocess.check_output("grep '^ftp:' /etc/passwd | awk -F: '{print $7}'", shell=True, text=True).strip()

        # FTP 포트가 수신 중인지 확인합니다
        ss_output = subprocess.check_output(["ss", "-tnlp"], text=True)
        if re.search(r':21', ss_output):
            if ftp_shell == "/bin/false":
                results["진단 결과"] = "양호"
                results["현황"].append("FTP 계정의 셸이 /bin/false로 설정되었습니다.")
            else:
                results["진단 결과"] = "취약"
                results["현황"].append("FTP 계정의 셸이 /bin/false로 설정되지 않았습니다.")
        else:
            results["진단 결과"] = "양호"
            results["현황"].append("FTP 포트(21)가 열려 있지 않습니다.")
    except subprocess.CalledProcessError:
        results["현황"].append("FTP 계정 정보를 검색하는 데 실패하였습니다.")

    return results

def main():
    results = check_ftp_account_shell_restriction()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
