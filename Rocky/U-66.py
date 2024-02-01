#!/usr/bin/python3
import subprocess
import json

def check_snmp_service_status():
    results = {
        "분류": "시스템 설정",
        "코드": "U-66",
        "위험도": "상",
        "진단 항목": "SNMP 서비스 구동 점검",
        "진단 결과": "",
        "현황": [],
        "대응방안": "[양호]: SNMP 서비스를 사용하지 않는 경우\n[취약]: SNMP 서비스를 사용하는 경우"
    }

    try:
        snmp_status = subprocess.run(["systemctl", "is-active", "snmpd"], capture_output=True, text=True)
        if snmp_status.returncode == 0:
            results["진단 결과"] = "취약"
            results["현황"].append("SNMP 서비스가 활성되어 있습니다.")
        else:
            results["진단 결과"] = "양호"
            results["현황"].append("SNMP 서비스가 활성화되지 않았습니다.")
    except Exception as e:
        results["현황"].append(f"SNMP 서비스 상태 확인 중 오류 발생: {e}")

    return results

def main():
    results = check_snmp_service_status()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()