#!/bin/python3

import subprocess
import json

# /etc/passwd에서 FTP 계정의 셸 확인
def check_ftp_account_shell():
    try:
        passwd_content = subprocess.check_output("grep '^ftp:' /etc/passwd", shell=True, text=True)
        ftp_shell = passwd_content.strip().split(":")[-1]
        if ftp_shell == "/bin/false":
            return True
        else:
            return False
    except subprocess.CalledProcessError:
        # grep 명령 실패 (ftp 계정이 없는 경우 등)
        return None

ftp_shell_ok = check_ftp_account_shell()

# 결과 저장을 위한 딕셔너리
results = {
    "분류": "서비스 관리",
    "코드": "U-62",
    "위험도": "상",
    "진단 항목": "ftp 계정 shell 제한",
    "진단 결과": "",
    "현황": "",
    "대응방안": ""
}

if ftp_shell_ok is True:
    results["진단 결과"] = "양호"
    results["현황"] = "ftp 계정에 /bin/false 쉘이 부여되어 있습니다."
    results["대응방안"] = "현재 설정을 유지하세요."
elif ftp_shell_ok is False:
    results["진단 결과"] = "취약"
    results["현황"] = "ftp 계정에 /bin/false 쉘이 부여되지 않았습니다."
    results["대응방안"] = "/etc/passwd 파일에서 ftp 계정의 쉘을 /bin/false로 설정하세요."
else:
    results["진단 결과"] = "정보 부족"
    results["현황"] = "ftp 계정을 확인할 수 없습니다."
    results["대응방안"] = "시스템에서 ftp 계정의 필요성을 검토하고, 존재하는 경우 적절한 쉘 제한을 적용하세요."

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
