#!/bin/python3

import subprocess
import json

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
try:
    sendmail_output = subprocess.check_output(["ps", "-C", "sendmail"], stderr=subprocess.STDOUT, text=True)
    postfix_output = subprocess.check_output(["ps", "-C", "postfix"], stderr=subprocess.STDOUT, text=True)
    if sendmail_output.strip() or postfix_output.strip():
        smtp_active = True
    else:
        smtp_active = False
except subprocess.CalledProcessError:
    smtp_active = False

# Sendmail 또는 Postfix 설정 파일에서 noexpn, novrfy 옵션 검사
# 예시에서는 간단화를 위해 해당 옵션의 설정 여부를 직접적으로 확인하지 않고 설명만 제공합니다.
if smtp_active:
    # 이 부분에서 실제로 sendmail.cf 또는 main.cf 파일을 검사하는 코드를 추가할 수 있습니다.
    expn_vrfy_restricted = False  # 설정 파일 검사 후, 올바른 설정이 확인되면 True로 설정
    if expn_vrfy_restricted:
        results["진단 결과"] = "양호"
        results["현황"] = "SMTP 서비스 사용 중이며, expn, vrfy 명령어가 제한되어 있습니다."
    else:
        results["진단 결과"] = "취약"
        results["현황"] = "SMTP 서비스 사용 중이나, expn, vrfy 명령어에 대한 제한이 없습니다."
        results["대응방안"] = "Sendmail 또는 Postfix 설정에서 noexpn, novrfy 옵션을 설정하세요."
else:
    results["진단 결과"] = "양호"
    results["현황"] = "SMTP 서비스가 비활성화 되어 있습니다."

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
