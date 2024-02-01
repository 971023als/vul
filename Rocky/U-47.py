#!/usr/bin/python3
import re
import json

def check_password_max_age():
    results = {
        "분류": "패스워드 정책",
        "코드": "U-47",
        "위험도": "상",
        "진단 항목": "패스워드 최대 사용기간 설정",
        "진단 결과": "",
        "현황": [],
        "대응방안": "패스워드 최대 사용기간을 90일 이하로 설정"
    }

    pass_max_days = 0
    with open('/etc/login.defs', 'r') as f:
        for line in f:
            if re.match(r'^PASS_MAX_DAYS\s+\d+', line):
                pass_max_days = int(line.split()[1])
                break

    if pass_max_days <= 90:
        results["현황"].append(f"패스워드 최대 사용기간이 {pass_max_days}일로 설정되어 있습니다.")
        results["진단 결과"] = "양호"
    else:
        results["현황"].append(f"패스워드 최대 사용기간이 {pass_max_days}일로 설정되어 있습니다. 90일을 초과합니다.")
        results["진단 결과"] = "취약"

    return results

def main():
    results = check_password_max_age()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
