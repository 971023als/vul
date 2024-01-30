#!/usr/bin/python3

import json
import subprocess

# 결과를 저장할 딕셔너리
results = {
    "U-04": {
        "title": "패스워드 파일 보호",
        "status": "",
        "description": {
            "good": "쉐도우 패스워드를 사용하거나, 패스워드를 암호화하여 저장하는 경우",
            "bad": "쉐도우 패스워드를 사용하지 않고, 패스워드를 암호화하여 저장하지 않는 경우"
        },
        "message": ""
    }
}

def check_password_protection():
    shadow_file = "/etc/shadow"
    passwd_file = "/etc/passwd"

    try:
        # 쉐도우 파일 존재 여부 검사
        with open(shadow_file) as f:
            results["U-04"]["message"] += "쉐도우 파일이 존재합니다. "

        # /etc/passwd 파일에서 패스워드 필드(x) 검사
        with open(passwd_file) as f:
            content = f.readlines()
            encrypted_passwords = all('x' == line.split(':')[1] for line in content)
            if encrypted_passwords:
                results["U-04"]["status"] = "양호"
                results["U-04"]["message"] += "쉐도우 패스워드를 사용하거나, 패스워드를 암호화하여 저장하는 경우"
            else:
                results["U-04"]["status"] = "취약"
                results["U-04"]["message"] += "쉐도우 패스워드를 사용하지 않고, 패스워드를 암호화하여 저장하지 않는 경우"
    except FileNotFoundError as e:
        results["U-04"]["status"] = "오류"
        results["U-04"]["message"] = str(e)

# 검사 수행
check_password_protection()

# 결과를 JSON 파일로 저장
with open('U-04.json', 'w', encoding='utf-8') as f:
    json.dump(results, f, ensure_ascii=False, indent=4)

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
