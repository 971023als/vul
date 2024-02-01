#!/usr/bin/python3
import re
import json

def check_account_lock_threshold():
    results = {
        "분류": "시스템 설정",
        "코드": "U-03",
        "위험도": "상",
        "진단 항목": "계정 잠금 임계값 설정",
        "진단 결과": "",
        "현황": [],
        "대응방안": "[양호]: 계정 잠금 임계값이 10회 이하의 값으로 설정되어 있는 경우\n[취약]: 계정 잠금 임계값이 설정되어 있지 않거나, 10회 이하의 값으로 설정되지 않은 경우"
    }

    pam_file = "/etc/pam.d/system-auth"
    expected_pattern = re.compile(r"auth\s+required\s+pam_tally2\.so\s+deny=10\s+unlock_time=900")

    try:
        with open(pam_file, 'r') as file:
            content = file.read()
            if expected_pattern.search(content):
                results["진단 결과"] = "양호"
                results["현황"].append("auth required pam_tally2.so deny=10 unlock_time=900 존재.")
            else:
                results["진단 결과"] = "취약"
                results["현황"].append("auth required pam_tally2.so deny=10 unlock_time=900 없음.")
    except FileNotFoundError:
        results["진단 결과"] = "파일없음"
        results["현황"].append(f"{pam_file} 파일이 존재하지 않습니다.")

    return results

def main():
    results = check_account_lock_threshold()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
