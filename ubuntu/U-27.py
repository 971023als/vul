import subprocess
import json

# 결과를 저장할 딕셔너리
results = {
    "U-27": {
        "title": "RPC 서비스 확인 '확인 필요'",
        "status": "",
        "description": {
            "good": "불필요한 RPC 서비스가 비활성화 되어 있는 경우",
            "bad": "불필요한 RPC 서비스가 활성화 되어 있는 경우",
        },
        "services": []
    }
}

def check_rpc_services():
    services = [
        "rpc.cmsd", "rpc.ttdbserverd", "sadmin", "rusersd", "walld", "sprayd",
        "rstatd", "rpc.nisd", "rexd", "rpc.pcnfsd", "rpc.statd", "rpc.ypupdated",
        "rpc.requotad", "kcms_server", "cachefsd"
    ]

    for service in services:
        try:
            # 시스템의 서비스 관리 도구를 사용하여 서비스 상태 확인
            result = subprocess.run(["systemctl", "status", service], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            # 활성 상태면 경고, 아니면 OK
            if "active (running)" in result.stdout.decode('utf-8'):
                results["services"].append(f"{service} 서비스가 활성화되어 있습니다.")
                results["status"] = "취약"
            else:
                results["services"].append(f"{service} 서비스가 활성화되지 않았습니다.")
        except Exception as e:
            results["services"].append(f"{service} 서비스 상태 확인 중 오류 발생: {e}")

    if not results["status"]:
        results["status"] = "양호"

# 검사 수행
check_rpc_services()

# 결과를 JSON 파일로 저장
with open('result.json', 'w', encoding='utf-8') as f:
    json.dump(results, f, ensure_ascii=False, indent=4)

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
