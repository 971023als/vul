#!/usr/bin/env python3
import json
import os

# 결과를 저장할 딕셔너리
results = {
    "U-21": {
        "title": "r 계열 서비스 비활성화",
        "status": "양호",
        "description": {
            "good": "r 계열 서비스가 비활성화 되어 있는 경우",
            "bad": "r 계열 서비스가 활성화 되어 있는 경우"
        },
        "details": []
    }
}

# 검사할 파일과 예상 설정
files = ["/etc/xinetd.d/rlogin", "/etc/xinetd.d/rsh", "/etc/xinetd.d/rexec"]
expected_settings = [
    "socket_type= stream",
    "wait= no",
    "user= nobody",
    "log_on_success+= USERID",
    "log_on_failure+= USERID",
    "disable= yes"
]

def check_r_services():
    for file in files:
        if not os.path.exists(file):
            results["U-21"]["details"].append(f"{file} 파일이 없습니다.")
            continue
        
        with open(file, 'r') as f:
            file_content = f.read()
        
        missing_settings = [setting for setting in expected_settings if setting not in file_content]
        if missing_settings:
            results["U-21"]["status"] = "취약"
            results["U-21"]["details"].append(f"{file} 파일에서 누락된 설정: {', '.join(missing_settings)}")
        else:
            results["U-21"]["details"].append(f"{file}의 모든 예상 설정이 올바르게 적용되었습니다.")

check_r_services()

# 결과 파일에 JSON 형태로 저장
result_file = 'r_services_disable_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
