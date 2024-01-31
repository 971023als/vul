#!/usr/bin/env python3
import json
import re

# 결과를 저장할 딕셔너리
results = {
    "U-46": {
        "title": "패스워드 최소 길이 설정",
        "status": "",
        "description": {
            "good": "패스워드 최소 길이가 8자 이상으로 설정되어 있는 경우",
            "bad": "패스워드 최소 길이가 8자 미만으로 설정되어 있는 경우"
        },
        "details": []
    }
}

def check_password_min_length():
    # login.defs 파일을 읽어 PASS_MIN_LEN 값을 찾습니다
    try:
        with open('/etc/login.defs', 'r') as file:
            content = file.read()
            match = re.search(r'^PASS_MIN_LEN\s+(\d+)', content, re.MULTILINE)
            if match:
                pass_min_len = int(match.group(1))
                if pass_min_len < 8:
                    results["U-46"]["status"] = "취약"
                    results["U-46"]["details"].append(f"패스워드 최소 길이가 8자 미만으로 설정되어 있습니다: {pass_min_len}자")
                else:
                    results["U-46"]["status"] = "양호"
                    results["U-46"]["details"].append(f"패스워드 최소 길이가 8자 이상으로 설정되어 있습니다: {pass_min_len}자")
            else:
                results["U-46"]["status"] = "취약"
                results["U-46"]["details"].append("PASS_MIN_LEN 설정을 찾을 수 없습니다.")
    except FileNotFoundError:
        results["U-46"]["status"] = "취약"
        results["U-46"]["details"].append("/etc/login.defs 파일을 찾을 수 없습니다.")

check_password_min_length()

# 결과 파일에 JSON 형태로 저장
result_file = 'password_min_length_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
