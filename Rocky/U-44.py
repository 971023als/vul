#!/usr/bin/python3
import subprocess
import json

def check_root_uid_accounts():
    results = {
        "분류": "계정 관리",
        "코드": "U-44",
        "위험도": "상",
        "진단 항목": "root 이외의 UID가 '0' 금지",
        "진단 결과": "",
        "현황": [],
        "대응방안": "root 계정 외에 UID가 '0'인 계정을 사용하지 않아야 합니다."
    }

    # /etc/passwd 파일에서 UID가 0인 계정을 찾습니다.
    with open('/etc/passwd', 'r') as f:
        for line in f:
            parts = line.strip().split(':')
            if parts[2] == '0':
                results["현황"].append(f"{parts[0]} 계정의 UID는 {parts[2]}입니다.")

    # 진단 결과 업데이트
    if len(results["현황"]) > 1:
        results["진단 결과"] = "취약"
        results["현황"].append("root 계정과 동일한 UID를 갖는 추가 계정이 있습니다.")
    else:
        results["진단 결과"] = "양호"
        results["현황"].append("root 계정 외에 UID가 '0'인 계정이 없습니다.")

    return results

def main():
    results = check_root_uid_accounts()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
