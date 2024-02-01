#!/bin/python3

import subprocess
import json
import re

# 결과 저장을 위한 딕셔너리
results = {
    "분류": "서비스 관리",
    "코드": "U-70",
    "위험도": "상",
    "진단 항목": "expn, vrfy 명령어 제한",
    "진단 결과": "",
    "현황": "",
    "대응방안": ""
}

# Sendmail 또는 Postfix 서비스 실행 여부 확인
smtp_active = False
try:
    sendmail_output = subprocess.check_output(["ps", "-C", "sendmail"], stderr=subprocess.STDOUT, text=True)
    if sendmail_output.strip():
        smtp_active = True
        config_file = "/etc/mail/sendmail.cf"
except subprocess.CalledProcessError:
    pass

try:
    postfix_output = subprocess.check_output(["ps", "-C", "postfix"], stderr=subprocess.STDOUT, text=True)
    if postfix_output.strip():
        smtp_active = True
        config_file = "/etc/postfix/main.cf"
except subprocess.CalledProcessError:
    pass

# 설정 파일에서 noexpn, novrfy 옵션 검사
expn_vrfy_restricted = False
if smtp_active:
    try:
        with open(config_file, 'r') as file:
            content = file.read()
            if "noexpn" in content and "novrfy" in content:
                expn_vrfy_restricted = True
    except FileNotFoundError:
        results["현황"] = f"{config_file} 파일을 찾을 수 없습니다."

    if expn_vrfy_restricted:
        results["진단 결과"] = "양호"
        results["현황"] = f"SMTP 서비스 사용 중이며, expn, vrfy 명령어가 {config_file}에서 제한되어 있습니다."
    else:
        results["진단 결과"] = "취약"
        results["현황"] = f"SMTP 서비스 사용 중이나, expn, vrfy 명령어에 대한 제한이 {config_file}에서 설정되지 않았습니다."
        results["대응방안"] = f"Sendmail 또는 Postfix 설정 파일({config_file})에서 noexpn, novrfy 옵션을 설정하세요."
else:
    results["진단 결과"] = "양호"
    results["현황"] = "SMTP 서비스가 비활성화 되어 있습니다."

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
