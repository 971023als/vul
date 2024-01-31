#!/usr/bin/env python3
import json
import subprocess

# 결과를 저장할 딕셔너리
results = {
    "U-53": {
        "title": "사용자 shell 점검",
        "status": "",
        "description": {
            "good": "로그인이 필요하지 않은 계정에 /bin/false(nologin) 쉘이 부여되지 않은 경우",
            "bad": "로그인이 필요하지 않은 계정에 /bin/false(nologin) 쉘이 부여되어 있는 경우"
        },
        "details": []
    }
}

def check_user_shells():
    with open('/etc/passwd', 'r') as f:
        lines = f.readlines()

    for line in lines:
        if any(user in line for user in ["daemon", "bin", "sys", "adm", "listen", "nobody", "nobody4", "noaccess", "diag", "operator", "games", "gopher"]) and "admin" not in line:
            parts = line.strip().split(':')
            username = parts[0]
            shell = parts[-1]
            if shell in ["/bin/false", "/sbin/nologin"]:
                results["U-53"]["details"].append(f"사용자 {username}의 셸이 {shell}로 설정됨: 양호")
            else:
                results["U-53"]["status"] = "취약"
                results["U-53"]["details"].append(f"사용자 {username}의 셸이 /bin/false 또는 /sbin/nologin으로 설정되어 있지 않습니다. 현재 셸은 {shell}입니다.")

    if not results["U-53"]["details"]:
        results["U-53"]["status"] = "양호"
    else:
        results["U-53"]["status"] = "취약"

check_user_shells()

# 결과 파일에 JSON 형태로 저장
result_file = 'user_shell_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
