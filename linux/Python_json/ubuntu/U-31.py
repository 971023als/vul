#!/usr/bin/python3
import os
import re
import json
from glob import glob

def check_spam_mail_relay_restrictions():
    results = {
        "분류": "서비스 관리",
        "코드": "U-31",
        "위험도": "상",
        "진단 항목": "스팸 메일 릴레이 제한",
        "진단 결과": None,  # 초기 상태는 None으로 설정
        "현황": [],
        "대응방안": "SMTP 서비스 릴레이 제한 설정"
    }

    search_directory = '/etc/mail/'
    sendmail_cf_files = glob(os.path.join(search_directory, 'sendmail.cf'))

    if sendmail_cf_files:
        for file_path in sendmail_cf_files:
            with open(file_path, 'r') as file:
                content = file.read()
                # 릴레이 제한 설정을 보다 명확하게 검사
                if "R$\*" in content or re.search(r'DS', content):
                    results["진단 결과"] = "양호"
                    results["현황"].append(f"{file_path} 파일에 릴레이 제한이 적절히 설정되어 있습니다.")
                else:
                    results["진단 결과"] = "취약"
                    results["현황"].append(f"{file_path} 파일에 릴레이 제한 설정이 없습니다.")
                    break
    else:
        results["진단 결과"] = "오류"
        results["현황"].append("sendmail.cf 파일을 찾을 수 없습니다.")

    return results

def main():
    results = check_spam_mail_relay_restrictions()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
