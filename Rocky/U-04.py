#!/usr/bin/python3
import os
import json

def check_shadow_password_usage():
    results = {
        "분류": "계정 관리",
        "코드": "U-04",
        "위험도": "상",
        "진단 항목": "패스워드 파일 보호",
        "진단 결과": "",
        "현황": [],
        "대응방안": "쉐도우 패스워드 사용 또는 패스워드 암호화 저장"
    }

    passwd_file = "/etc/passwd"
    vulnerable = False

    if os.path.exists(passwd_file):
        with open(passwd_file, "r") as file:
            for line in file:
                parts = line.strip().split(":")
                if len(parts) > 1 and parts[1] != "x":
                    vulnerable = True
                    break  # Stop checking further as we found a non-shadowed password

    if vulnerable:
        results["현황"].append("쉐도우 패스워드를 사용하고 있지 않습니다.")
        results["진단 결과"] = "취약"
    else:
        results["진단 결과"] = "양호"

    return results

def main():
    results = check_shadow_password_usage()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
