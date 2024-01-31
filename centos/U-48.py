#!/usr/bin/env python3
import json
import re

# 결과를 저장할 딕셔너리
results = {
    "U-48": {
        "title": "패스워드 최소 사용기간 설정",
        "status": "",
        "description": {
            "good": "패스워드 최소 사용기간이 1일(1주)로 설정되어 있는 경우",
            "bad": "패스워드 최소 사용기간이 설정되어 있지 않는 경우"
        },
        "details": []
    }
}

def check_password_min_usage():
    min_days = 7  # 최소 사용 기간을 7일로 설정
    with open('/etc/login.defs', 'r') as file:
        for line in file:
            if line.startswith("PASS_MIN_DAYS"):
                pass_min_days = int(line.split()[1])
                if pass_min_days >= min_days:
                    results["U-48"]["status"] = "양호"
                    results["U-48"]["details"].append(f"패스워드 최소 사용기간이 {pass_min_days}일로 설정되어 있습니다.")
                else:
                    results["U-48"]["status"] = "취약"
                    results["U-48"]["details"].append(f"패스워드 최소 사용기간이 설정되어 있지 않습니다.")
                return

    results["U-48"]["status"] = "취약"
    results["U-48"]["details"].append("/etc/login.defs 파일에서 PASS_MIN_DAYS 설정을 찾을 수 없습니다.")

check_password_min_usage()

# 결과 파일에 JSON 형태로 저장
result_file = 'password_min_usage_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
