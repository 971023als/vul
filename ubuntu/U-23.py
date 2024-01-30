import os
import glob
import json

# 결과를 저장할 딕셔너리
results = {
    "U-23": {
        "title": "DoS 공격에 취약한 서비스 비활성화",
        "status": "",
        "description": {
            "good": "DoS 공격에 취약한 서비스가 비활성화된 경우",
            "bad": "DoS 공격에 취약한 서비스 활성화된 경우",
        },
        "services": []
    }
}

def check_service(service_name):
    service_files = glob.glob(f'/etc/xinetd.d/{service_name}*')
    if not service_files:
        results["services"].append(f"{service_name} 서비스 관련 파일이 존재하지 않습니다.")
        return
    
    for service_file in service_files:
        with open(service_file, 'r') as file:
            content = file.read()
            if 'disable = yes' in content:
                results["services"].append(f"{service_file}에 대한 서비스가 비활성화 되어 있습니다.")
            else:
                results["status"] = "취약"
                results["services"].append(f"{service_file}에 대한 서비스가 활성화 되어 있습니다.")

# 검사 수행
for service in ["echo", "discard", "daytime", "chargen"]:
    check_service(service)

if not results["status"]:
    results["status"] = "양호"

# 결과를 JSON 파일로 저장
with open('result.json', 'w', encoding='utf-8') as f:
    json.dump(results, f, ensure_ascii=False, indent=4)

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
