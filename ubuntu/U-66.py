#!/usr/bin/env python3
import json
import subprocess

# 결과를 저장할 딕셔너리
results = {
    "U-66": {
        "title": "SNMP 서비스 구동 점검",
        "status": "",
        "description": {
            "good": "SNMP 서비스를 사용하지 않는 경우",
            "bad": "SNMP 서비스를 사용하는 경우"
        },
        "details": []
    }
}

def check_snmp_service():
    try:
        # systemctl을 사용하여 snmpd 서비스 상태 확인
        service_status = subprocess.run(["systemctl", "is-active", "snmpd"], capture_output=True, text=True)
        if service_status.returncode == 0:
            results["U-66"]["status"] = "취약"
            results["U-66"]["details"].append("SNMP 서비스가 활성되어 있습니다.")
        else:
            results["U-66"]["status"] = "양호"
            results["U-66"]["details"].append("SNMP 서비스가 활성화되지 않았습니다.")
    except subprocess.SubprocessError as e:
        results["U-66"]["details"].append(f"SNMP 서비스 상태 확인 중 오류 발생: {e}")

check_snmp_service()

# 결과 파일에 JSON 형태로 저장
result_file = 'snmp_service_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
