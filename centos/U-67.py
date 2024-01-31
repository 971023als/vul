#!/bin/python3

import json

# SNMP 설정 파일 경로
snmpd_config_file = "/etc/snmp/snmpd.conf"

# 결과 저장을 위한 딕셔너리
results = {
    "분류": "서비스 관리",
    "코드": "U-67",
    "위험도": "상",
    "진단 항목": "SNMP 서비스 Community String의 복잡성 설정",
    "진단 결과": "",
    "현황": [],
    "대응방안": ""
}

try:
    # snmpd.conf 파일에서 community 설정 검사
    with open(snmpd_config_file, 'r') as file:
        for line in file:
            if line.startswith('com2sec') or line.startswith('community'):
                community_name = line.split()[1]
                if community_name.lower() in ['public', 'private']:
                    results["현황"].append(f"취약: Community 이름이 '{community_name}' 입니다.")
                    results["진단 결과"] = "취약"
                else:
                    results["현황"].append(f"양호: Community 이름이 '{community_name}' 입니다.")
    if not results["현황"]:
        results["현황"].append("SNMP Community 설정이 발견되지 않았습니다.")
        results["진단 결과"] = "정보 부족"
except FileNotFoundError:
    results["현황"].append("snmpd.conf 파일이 없습니다.")
    results["진단 결과"] = "정보 부족"

# 대응방안 설정
if results["진단 결과"] == "취약":
    results["대응방안"] = "기본 Community 이름('public', 'private') 대신 복잡성이 높은 이름을 사용하세요."
else:
    results["대응방안"] = "현재 설정을 유지하세요."

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
