#!/bin/python3

import subprocess
import json

def check_snmp_service_availability():
    # SNMP 서비스 프로세스를 확인합니다.
    try:
        subprocess.check_output(['pgrep', '-f', 'snmp'], stderr=subprocess.STDOUT)
        return True
    except subprocess.CalledProcessError:
        return False

def check_snmp_service():
    results = []
    snmp_service_available = check_snmp_service_availability()

    # SNMP 서비스 사용 여부에 따른 결과 메시지와 조치 사항을 설정합니다.
    if snmp_service_available:
        service_status = "취약"
        message = "SNMP 서비스를 사용하고 있습니다."
        action = "불필요한 경우 SNMP 서비스 비활성화 권장"
    else:
        service_status = "양호"
        message = "SNMP 서비스를 사용하지 않고 있습니다."
        action = "현재 상태 유지"

    # 결과 정보를 딕셔너리에 추가합니다.
    result = {
        "분류": "네트워크 서비스",
        "코드": "U-66",
        "위험도": "높음" if service_status == "취약" else "낮음",
        "진단 항목": "SNMP 서비스 구동 점검",
        "진단 결과": service_status,
        "현황": message,
        "대응방안": action,
        "결과": "경고" if service_status == "취약" else "정상"
    }

    results.append(result)
    return results

def save_results_to_json(results, file_path):
    with open(file_path, 'w') as f:
        json.dump(results, f, ensure_ascii=False, indent=4)

def main():
    results = check_snmp_service()
    save_results_to_json(results, "snmp_service_check_result.json")
    print("SNMP 서비스 구동 점검 결과를 snmp_service_check_result.json 파일에 저장하였습니다.")

if __name__ == "__main__":
    main()
