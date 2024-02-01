#!/usr/bin/python3
import subprocess
import os
import re
import json

def check_spam_mail_relay_restrictions():
    results = {
        "분류": "서비스 관리",
        "코드": "U-31",
        "위험도": "상",
        "진단 항목": "스팸 메일 릴레이 제한",
        "진단 결과": "양호",  # Assume "Good" until proven otherwise
        "현황": [],
        "대응방안": "SMTP 서비스 릴레이 제한 설정"
    }

    try:
        # Find sendmail.cf files
        find_command = "find / -name 'sendmail.cf' -type f 2>/dev/null"
        sendmail_cf_files = subprocess.check_output(find_command, shell=True, text=True).strip().split('\n')

        if sendmail_cf_files:
            for file_path in sendmail_cf_files:
                if file_path:  # Check if file path is not empty
                    with open(file_path, 'r') as file:
                        content = file.read()
                        if not re.search(r'^#|^\s#', content) and not re.search(r'R\$\*', content) and not re.search(r'Relaying denied', content, re.IGNORECASE):
                            results["진단 결과"] = "취약"
                            results["현황"].append(f"{file_path} 파일에 릴레이 제한이 설정되어 있지 않습니다.")
                            break

        if results["진단 결과"] == "양호":
            results["현황"].append("모든 sendmail.cf 파일에 릴레이 제한이 적절히 설정되어 있습니다.")

    except subprocess.CalledProcessError as e:
        results["진단 결과"] = "오류"
        results["현황"].append(f"sendmail.cf 파일 검색 중 오류 발생: {e}")

    return results

def main():
    results = check_spam_mail_relay_restrictions()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
