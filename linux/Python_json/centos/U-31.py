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
        "진단 결과": None,  # 초기 상태 설정, 검사 후 결과에 따라 업데이트
        "현황": [],
        "대응방안": "SMTP 서비스 릴레이 제한 설정"
    }

    relay_restriction_found = False

    try:
        # sendmail.cf 파일들 찾기
        find_command = "find / -name 'sendmail.cf' -type f 2>/dev/null"
        sendmail_cf_files = subprocess.check_output(find_command, shell=True, text=True).strip().split('\n')

        if sendmail_cf_files:
            for file_path in sendmail_cf_files:
                if file_path:  # 파일 경로가 비어 있지 않은 경우
                    with open(file_path, 'r') as file:
                        content = file.read()
                        # 릴레이 제한 설정 검사
                        if re.search(r'R\$\*', content) or re.search(r'Relaying denied', content, re.IGNORECASE):
                            relay_restriction_found = True
                        else:
                            results["진단 결과"] = "취약"
                            results["현황"].append(f"{file_path} 파일에 릴레이 제한이 설정되어 있지 않습니다.")
                            break

        if relay_restriction_found or not sendmail_cf_files:
            results["진단 결과"] = "양호"
            results["현황"].append("모든 sendmail.cf 파일에 릴레이 제한이 적절히 설정되어 있습니다.")

    except subprocess.CalledProcessError as e:
        results["진단 결과"] = "오류"
        results["현황"].append(f"sendmail.cf 파일 검색 중 오류 발생: {e}")

    # 진단 결과가 명시적으로 설정되지 않은 경우 기본값을 "양호"로 설정
    if results["진단 결과"] is None:
        results["진단 결과"] = "양호"
        results["현황"].append("sendmail.cf 파일에 대한 검사를 수행할 수 없습니다.")

    return results

def main():
    results = check_spam_mail_relay_restrictions()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
