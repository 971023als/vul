#!/usr/bin/python3
import subprocess
import json

def check_ftp_account_shell_restriction():
    results = {
        "분류": "서비스 관리",
        "코드": "U-62",
        "위험도": "중",
        "진단 항목": "ftp 계정 shell 제한",
        "진단 결과": "취약",  # Assume "Vulnerable" until proven otherwise
        "현황": "ftp 계정에 /bin/false 쉘이 부여되어 있지 않습니다.",
        "대응방안": "ftp 계정에 /bin/false 쉘 부여"
    }

    try:
        with open('/etc/passwd', 'r') as passwd_file:
            for line in passwd_file:
                fields = line.strip().split(':')
                if fields[0] == 'ftp' and fields[-1] == '/bin/false':
                    results["진단 결과"] = "양호"
                    results["현황"] = "ftp 계정에 /bin/false 쉘이 부여되어 있습니다."
                    break
    except FileNotFoundError:
        results["현황"] = "/etc/passwd 파일을 찾을 수 없습니다."

    return results

def main():
    ftp_shell_restriction_check_results = check_ftp_account_shell_restriction()
    print(ftp_shell_restriction_check_results)

if __name__ == "__main__":
    main()
