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
        "진단 결과": None,  # 기본적으로 오류로 설정
        "현황": [],
        "대응방안": "SMTP 서비스 릴레이 제한 설정"
    }

    try:
        # Specify the directory where sendmail.cf might be located
        search_directory = '/etc/mail/'

        # Search for sendmail.cf file in the specified directory
        sendmail_cf_files = subprocess.check_output(f"find {search_directory} -name 'sendmail.cf' -type f 2>/dev/null", shell=True, text=True).strip().split('\n')

        if not sendmail_cf_files:
            raise FileNotFoundError("sendmail.cf 파일을 찾을 수 없습니다.")

        for file_path in sendmail_cf_files:
            with open(file_path, 'r') as file:
                content = file.read()
                if re.search(r'R\$\*', content) or re.search(r'Relaying denied', content, re.IGNORECASE):
                    results["진단 결과"] = "양호"
                    results["현황"].append(f"{file_path} 파일에 릴레이 제한이 적절히 설정되어 있습니다.")
                else:
                    results["진단 결과"] = "취약"
                    results["현황"].append(f"{file_path} 파일에 릴레이 제한 설정이 없습니다.")
                    break

    except FileNotFoundError as e:
        results["진단 결과"] = "오류"
        results["현황"].append(str(e))
    except Exception as e:
        results["진단 결과"] = "오류"
        results["현황"].append(f"예상치 못한 오류 발생: {e}")

    return results

def main():
    results = check_spam_mail_relay_restrictions()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
