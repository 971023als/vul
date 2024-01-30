#!/usr/bin/env python3
import json
import re

# 결과를 저장할 딕셔너리
results = {
    "U-67": {
        "title": "SNMP 서비스 Community String의 복잡성 설정",
        "status": "",
        "description": {
            "good": "SNMP Community 이름이 public, private 이 아닌 경우",
            "bad": "SNMP Community 이름이 public, private 인 경우"
        },
        "details": []
    }
}

def check_snmp_community():
    snmpd_config_file = "/etc/snmp/snmpd.conf"
    
    try:
        with open(snmpd_config_file, 'r') as file:
            communities = re.findall(r'^\s*community\s+(\S+)', file.read(), re.MULTILINE)
            if not communities:
                results["U-67"]["details"].append("Community 설정이 발견되지 않았습니다.")
                results["U-67"]["status"] = "양호"
                return
            
            for community in communities:
                if community in ["public", "private"]:
                    results["U-67"]["status"] = "취약"
                    results["U-67"]["details"].append(f"Community name {community} 는 허용되지 않습니다.")
                else:
                    results["U-67"]["details"].append(f"Community name {community} 는 허용되고 있습니다.")
                    if results["U-67"]["status"] != "취약":
                        results["U-67"]["status"] = "양호"
    except FileNotFoundError:
        results["U-67"]["details"].append(f"{snmpd_config_file} 파일이 없습니다. 확인해주세요.")
        results["U-67"]["status"] = "정보"

check_snmp_community()

# 결과 파일에 JSON 형태로 저장
result_file = 'snmp_community_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
