#!/bin/python3

import subprocess
import json

# 결과 저장을 위한 딕셔너리
results = {
    "분류": "서비스 관리",
    "코드": "U-60",
    "위험도": "상",
    "진단 항목": "ssh 원격접속 허용",
    "진단 결과": "",
    "현황": "",
    "대응방안": ""
}

# SSH 바이너리 존재 여부 확인
try:
    subprocess.check_call(["command", "-v", "ssh"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    results["진단 결과"] = "양호"
    results["현황"] = "SSH가 설치되어 있으며, 안전한 원격 접속 프로토콜로 사용될 수 있습니다."
    results["대응방안"] = "SSH를 계속해서 안전한 원격 접속에 사용하세요."
except subprocess.CalledProcessError:
    results["진단 결과"] = "취약"
    results["현황"] = "SSH가 설치되어 있지 않습니다. 안전하지 않은 원격 접속 프로토콜이 사용될 위험이 있습니다."
    results["대응방안"] = "SSH를 설치하고, Telnet이나 FTP와 같은 안전하지 않은 프로토콜 대신 사용하세요."

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
