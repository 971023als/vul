#!/usr/bin/python3
import json
import re

def check_snmp_community_complexity():
    results = {
        "분류": "시스템 설정",
        "코드": "U-67",
        "위험도": "상",
        "진단 항목": "SNMP 서비스 Community String의 복잡성 설정",
        "진단 결과": "",
        "현황": [],
        "대응방안": "[양호]: SNMP Community 이름이 public, private 이 아닌 경우\n[취약]: SNMP Community 이름이 public, private 인 경우"
    }

    snmpd_config_file = "/etc/snmp/snmpd.conf"
    try:
        with open(snmpd_config_file, 'r') as file:
            communities = re.findall(r'^\s*community\s+(\S+)', file.read(), re.MULTILINE)
            if not communities:
                results["현황"].append("SNMP Community 이름을 찾을 수 없습니다.")
            else:
                for community in communities:
                    if community in ["public", "private"]:
                        results["진단 결과"] = "취약"
                        results["현황"].append(f"Community name {community}는 허용되지 않습니다.")
                    else:
                        results["현황"].append(f"Community name {community}는 허용되고 있습니다.")
    except FileNotFoundError:
        results["현황"].append(f"{snmpd_config_file} 파일이 없습니다. 확인해주세요.")
    except Exception as e:
        results["현황"].append(f"파일 읽기 중 예외 발생: {str(e)}")

    if "취약" not in results["진단 결과"]:
        results["진단 결과"] = "양호"

    return results

def main():
    results = check_snmp_community_complexity()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
