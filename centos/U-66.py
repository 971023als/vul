#!/bin/python3

import subprocess
import json

# 결과 저장을 위한 딕셔너리
results = {
    "분류": "서비스 관리",
    "코드": "U-66",
    "위험도": "상",
    "진단 항목": "SNMP 서비스 구동 점검",
    "진단 결과": "",
    "현황": "",
    "대응방안": ""
}

# SNMP 서비스 사용 여부 확인
try:
    # SNMP 프로세스가 실행 중인지 확인
    subprocess.check_output(["pgrep", "-f", "snmp"], stderr=subprocess.STDOUT)
    # 실행 중인 경우
    results["진단 결과"] = "취약"
    results["현황"] = "SNMP 서비스를 사용하고 있습니다."
    results["대응방안"] = "불필요한 경우 SNMP 서비스를 비활성화 하세요."
except subprocess.CalledProcessError:
    # 실행 중이지 않은 경우
    results["진단 결과"] = "양호"
    results["현황"] = "SNMP 서비스를 사용하지 않고 있습니다."
    results["대응방안"] = "현재 설정을 유지하세요."

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
