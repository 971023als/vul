#!/usr/bin/env python3
import json
import os

# 결과를 저장할 딕셔너리
results = {
    "U-04": {
        "title": "패스워드 파일 보호",
        "status": "",
        "description": {
            "good": "쉐도우 패스워드를 사용하거나, 패스워드를 암호화하여 저장하는 경우",
            "bad": "쉐도우 패스워드를 사용하지 않고, 패스워드를 암호화하여 저장하지 않는 경우"
        },
        "details": []
    }
}

def check_password_protection():
    shadow_file = "/etc/shadow"
    passwd_file = "/etc/passwd"
    
    if os.path.isfile(shadow_file):
        results["U-04"]["details"].append("쉐도우 파일이 존재합니다.")
        with open(passwd_file, 'r') as f:
            passwd_content = f.read()
        if 'x' in passwd_content:
            results["U-04"]["status"] = "양호"
            results["U-04"]["details"].append("쉐도우 패스워드를 사용하거나, 패스워드를 암호화하여 저장하는 경우")
        else:
            results["U-04"]["status"] = "취약"
            results["U-04"]["details"].append("쉐도우 패스워드를 사용하지 않고, 패스워드를 암호화하여 저장하지 않는 경우")
    else:
        results["U-04"]["status"] = "정보"
        results["U-04"]["details"].append("쉐도우 파일이 존재하지 않습니다.")

check_password_protection()

# 결과 파일에 JSON 형태로 저장
result_file = 'password_file_protection_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
