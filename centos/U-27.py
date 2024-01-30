#!/usr/bin/env python3
import json
import subprocess

# 결과를 저장할 딕셔너리
results = {
    "U-27": {
        "title": "RPC 서비스 확인",
        "status": "",
        "description": {
            "good": "불필요한 RPC 서비스가 비활성화 되어 있는 경우",
            "bad": "불필요한 RPC 서비스가 활성화 되어 있는 경우"
        },
        "details": []
    }
}

services = [
    "rpc.cmsd", "rpc.ttdbserverd", "sadmin", "rusersd", "walld", "sprayd",
    "rstatd", "rpc.nisd", "rexd", "rpc.pcnfsd", "rpc.statd", "rpc.ypupdated",
    "rpc.requotad", "kcms_server", "cachefsd"
]

def check_rpc_services():
    for service in services:
        try:
            # 시스템에서 서비스가 실행 중인지 확인
            process = subprocess.run(["pgrep", "-f", service], capture_output=True, text=True)
            if process.returncode == 0:
                results["U-27"]["status"] = "취약"
                results["U-27"]["details"].append(f"{service} 서비스가 활성화되어 있습니다.")
            else:
                results["U-27"]["details"].append(f"{service} 서비스가 활성화되지 않았습니다.")
        except Exception as e:
            results["U-27"]["details"].append(f"{service} 서비스 검사 중 오류 발생: {e}")

check_rpc_services()

# 결과 상태 결정
if "취약" not in results["U-27"]["status"]:
    results["U-27"]["status"] = "양호"

# 결과 파일에 JSON 형태로 저장
result_file = 'rpc_service_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
