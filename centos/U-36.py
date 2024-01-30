#!/usr/bin/env python3
import json
import subprocess

# 결과를 저장할 딕셔너리
results = {
    "U-36": {
        "title": "Apache 웹 프로세스 권한 제한",
        "status": "",
        "description": {
            "good": "Apache 데몬이 root 권한으로 구동되지 않는 경우",
            "bad": "Apache 데몬이 root 권한으로 구동되는 경우"
        },
        "details": []
    }
}

def check_apache_process_privilege():
    try:
        # Apache 프로세스 ID 가져오기
        pid = subprocess.check_output(["pgrep", "-x", "httpd"]).decode().strip()
        # Apache 프로세스의 사용자 및 그룹 가져오기
        process_info = subprocess.check_output(["ps", "-o", "user=,group=,cmd=", "-p", pid]).decode().strip()
        user, group, _ = process_info.split()

        if user == "root" or group == "root":
            results["U-36"]["status"] = "취약"
            results["U-36"]["details"].append(f"Apache 데몬(httpd)이 루트 권한으로 실행되고 있습니다: {user}, {group}")
        else:
            results["U-36"]["status"] = "양호"
            results["U-36"]["details"].append("Apache 데몬(httpd)이 루트 권한으로 실행되지 않습니다.")
    except subprocess.CalledProcessError as e:
        results["U-36"]["details"].append("Apache 데몬(httpd)이 실행되고 있지 않습니다.")
        results["U-36"]["status"] = "정보"

check_apache_process_privilege()

# 결과 파일에 JSON 형태로 저장
result_file = 'apache_process_privilege_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
