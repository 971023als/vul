#!/bin/python3

import os
import json

def check_snmp_community_string():
    results = []
    snmpd_config_file = "/etc/snmp/snmpd.conf"

    # snmpd.conf 파일이 있는지 확인합니다.
    if not os.path.isfile(snmpd_config_file):
        results.append({
            "분류": "네트워크 서비스",
            "코드": "U-67",
            "위험도": "정보",
            "진단 항목": "SNMP 서비스 Community String의 복잡성 설정",
            "진단 결과": "정보",
            "현황": "snmpd.conf 파일이 없습니다. 확인해주세요.",
            "대응방안": "SNMP 서비스 설정 확인 및 적절한 Community String 설정",
            "결과": "정보"
        })
        return results

    # snmpd.conf 파일에서 커뮤니티 이름 검색
    with open(snmpd_config_file, 'r') as file:
        communities = [line.split()[1] for line in file if line.startswith('community')]

    for community in communities:
        if community in ["public", "private"]:
            result = {
                "분류": "네트워크 서비스",
                "코드": "U-67",
                "위험도": "높음",
                "진단 항목": "SNMP 서비스 Community String의 복잡성 설정",
                "진단 결과": "취약",
                "현황": f"Community name {community}는 허용되지 않습니다.",
                "대응방안": "기본 Community 이름 변경 권장",
                "결과": "경고"
            }
        else:
            result = {
                "분류": "네트워크 서비스",
                "코드": "U-67",
                "위험도": "낮음",
                "진단 항목": "SNMP 서비스 Community String의 복잡성 설정",
                "진단 결과": "양호",
                "현황": f"Community name {community}는 허용되고 있습니다.",
                "대응방안": "현재 설정 유지",
                "결과": "정상"
            }
        results.append(result)

    return results

def save_results_to_json(results, file_path):
    with open(file_path, 'w') as f:
        json.dump(results, f, ensure_ascii=False, indent=4)

def main():
    results = check_snmp_community_string()
    save_results_to_json(results, "snmp_community_string_check_result.json")
    print("SNMP 서비스 Community String의 복잡성 설정 점검 결과를 snmp_community_string_check_result.json 파일에 저장하였습니다.")

if __name__ == "__main__":
    main()
