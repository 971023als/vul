#!/usr/bin/python3

import os
import json

# 결과를 저장할 딕셔너리
results = {
    "U-21": {
        "title": "r 계열 서비스 비활성화",
        "status": "",
        "description": {
            "good": "r 계열 서비스가 비활성화 되어 있는 경우",
            "bad": "r 계열 서비스가 활성화 되어 있는 경우",
        },
        "files": []
    }
}

expected_settings = [
    "socket_type= stream",
    "wait= no",
    "user= nobody",
    "log_on_success+= USERID",
    "log_on_failure+= USERID",
    "server= /usr/sdin/in.fingerd",
    "disable= yes"
]

def check_r_services():
    files = ["/etc/xinetd.d/rlogin", "/etc/xinetd.d/rsh", "/etc/xinetd.d/rexec"]
    all_settings_correct = True
    
    for file_path in files:
        if not os.path.exists(file_path):
            results["files"].append(f"{file_path} 파일이 없습니다.")
            continue

        with open(file_path, 'r') as file:
            file_contents = file.read()
            file_results = {"file": file_path, "issues": []}
            
            for setting in expected_settings:
                if setting not in file_contents:
                    all_settings_correct = False
                    file_results["issues"].append(f"'{setting}'이 올바르게 설정되지 않았습니다.")

            results["files"].append(file_results)

    if all_settings_correct:
        results["U-21"]["status"] = "양호"
        results["U-21"]["message"] = results["U-21"]["description"]["good"]
    else:
        results["U-21"]["status"] = "취약"
        results["U-21"]["message"] = results["U-21"]["description"]["bad"]

# 검사 수행
check_r_services()

# 결과를 JSON 파일로 저장
with open('result.json', 'w', encoding='utf-8') as f:
    json.dump(results, f, ensure_ascii=False, indent=4)

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
