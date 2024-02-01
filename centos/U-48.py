#!/usr/bin/python3
import re
import json

def check_password_min_age():
    results = {
        "분류": "패스워드 정책",
        "코드": "U-48",
        "위험도": "상",
        "진단 항목": "패스워드 최소 사용기간 설정",
        "진단 결과": "",
        "현황": [],
        "대응방안": "패스워드 최소 사용기간을 1일 이상으로 설정"
    }

    pass_min_days = 0
    with open('/etc/login.defs', 'r') as f:
        for line in f:
            if re.match(r'^PASS_MIN_DAYS\s+\d+', line):
                pass_min_days = int(line.split()[1])
                break

    if pass_min_days >= 1:
        results["현황"].append(f"패스워드 최소 사용기간이 {pass_min_days}일로 설정되어 있습니다.")
        results["진단 결과"] = "양호"
    else:
        results["현황"].append("패스워드 최소 사용기간이 설정되어 있지 않습니다.")
        results["진단 결과"] = "취약"

    return results

def main():
    results = check_password_min_age()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
