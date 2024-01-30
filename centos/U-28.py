#!/usr/bin/env python3
import json
import subprocess

# 결과를 저장할 딕셔너리
results = {
    "U-28": {
        "title": "NIS, NIS+ 점검",
        "status": "",
        "description": {
            "good": "NIS 서비스가 비활성화 되어 있거나, 필요 시 NIS+를 사용하는 경우",
            "bad": "NIS 서비스가 활성화 되어 있는 경우"
        },
        "details": []
    }
}

def check_nis_services():
    # NIS 관련 서비스 데몬이 실행 중인지 확인
    nis_services = ["ypserv", "ypbind", "ypxfrd", "rpc.yppasswdd", "rpc.ypupdated"]
    pattern = '|'.join(nis_services)
    process = subprocess.run(["pgrep", "-fl", pattern], capture_output=True, text=True)
    
    if process.stdout:
        results["U-28"]["status"] = "취약"
        for line in process.stdout.split('\n'):
            if line.strip():
                results["U-28"]["details"].append(f"{line}가 실행 중입니다.")
    else:
        results["U-28"]["status"] = "양호"
        results["U-28"]["details"].append("NIS 서비스가 비활성화되었습니다.")

check_nis_services()

# 결과 파일에 JSON 형태로 저장
result_file = 'nis_service_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
