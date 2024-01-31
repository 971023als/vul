#!/usr/bin/env python3
import json
import re

# 결과를 저장할 딕셔너리
results = {
    "U-47": {
        "title": "패스워드 최대 사용기간 설정",
        "status": "",
        "description": {
            "good": "패스워드 최대 사용기간이 90일(12주) 이하로 설정되어 있는 경우",
            "bad": "패스워드 최대 사용기간이 90일(12주) 이하로 설정되어 있지 않은 경우"
        },
        "details": []
    }
}

def check_password_max_age():
    max_days = 90
    with open('/etc/login.defs', 'r') as file:
        for line in file:
            if line.startswith("PASS_MAX_DAYS"):
                pass_max_days = int(line.split()[1])
                if pass_max_days <= max_days:
                    results["U-47"]["status"] = "양호"
                    results["U-47"]["details"].append(f"패스워드 최대 사용기간이 {pass_max_days}일로 설정되어 있습니다.")
                else:
                    results["U-47"]["status"] = "취약"
                    results["U-47"]["details"].append(f"패스워드 최대 사용기간이 {pass_max_days}일로 설정되어 있어, 권장 기간 {max_days}일을 초과합니다.")
                return

    results["U-47"]["status"] = "취약"
    results["U-47"]["details"].append("/etc/login.defs 파일에서 PASS_MAX_DAYS 설정을 찾을 수 없습니다.")

check_password_max_age()

# 결과 파일에 JSON 형태로 저장
result_file = 'password_max_age_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
