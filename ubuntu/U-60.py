#!/usr/bin/env python3
import json
import shutil

# 결과를 저장할 딕셔너리
results = {
    "U-60": {
        "title": "ssh 원격접속 허용",
        "status": "",
        "description": {
            "good": "원격 접속 시 SSH 프로토콜을 사용하는 경우",
            "bad": "원격 접속 시 Telnet, FTP 등 안전하지 않은 프로토콜을 사용하는 경우"
        },
        "details": []
    }
}

def check_ssh_installed():
    if shutil.which("ssh"):
        results["U-60"]["status"] = "양호"
        results["U-60"]["details"].append("SSH가 설치되었습니다.")
    else:
        results["U-60"]["status"] = "취약"
        results["U-60"]["details"].append("SSH가 설치되지 않았습니다.")

check_ssh_installed()

# 결과 파일에 JSON 형태로 저장
result_file = 'ssh_installation_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
