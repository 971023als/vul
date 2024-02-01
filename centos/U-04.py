#!/usr/bin/python3
import re
import json

def check_password_file_protection():
    results = {
        "분류": "시스템 설정",
        "코드": "U-04",
        "위험도": "상",
        "진단 항목": "패스워드 파일 보호",
        "진단 결과": "",
        "현황": [],
        "대응방안": "[양호]: 쉐도우 패스워드를 사용하거나, 패스워드를 암호화하여 저장하는 경우\n[취약]: 쉐도우 패스워드를 사용하지 않고, 패스워드를 암호화하여 저장하지 않는 경우"
    }

    shadow_file = "/etc/shadow"
    passwd_file = "/etc/passwd"

    if not os.path.exists(shadow_file):
        results["현황"].append("쉐도우 파일이 존재하지 않습니다.")
    else:
        results["현황"].append("쉐도우 파일이 존재합니다.")
        with open(passwd_file, 'r') as file:
            content = file.readlines()
            unencrypted_passwords = [line for line in content if not re.search(r':x:', line)]
            if unencrypted_passwords:
                results["진단 결과"] = "취약"
                results["현황"].append("쉐도우 패스워드를 사용하지 않고, 패스워드를 암호화하여 저장하지 않는 경우")
            else:
                results["진단 결과"] = "양호"
                results["현황"].append("쉐도우 패스워드를 사용하거나, 패스워드를 암호화하여 저장하는 경우")

    return results

def main():
    results = check_password_file_protection()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
