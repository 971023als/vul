#!/usr/bin/python3
import re
import json

def check_password_min_length():
    results = {
        "분류": "패스워드 정책",
        "코드": "U-46",
        "위험도": "상",
        "진단 항목": "패스워드 최소 길이 설정",
        "진단 결과": "",
        "현황": [],
        "대응방안": "패스워드 최소 길이를 8자 이상으로 설정"
    }

    pass_min_len = 0
    with open('/etc/login.defs', 'r') as f:
        for line in f:
            if re.match(r'^PASS_MIN_LEN\s+\d+', line):
                pass_min_len = int(line.split()[1])
                break

    if pass_min_len >= 8:
        results["현황"].append(f"패스워드 최소 길이가 {pass_min_len}자로 설정되어 있습니다.")
        results["진단 결과"] = "양호"
    else:
        results["현황"].append(f"패스워드 최소 길이가 {pass_min_len}자로 설정되어 있습니다. 8자 미만입니다.")
        results["진단 결과"] = "취약"

    return results

def main():
    results = check_password_min_length()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
