#!/usr/bin/python3
import subprocess
import re
import json

def check_smtp_restrictions():
    results = {
        "분류": "서비스 관리",
        "코드": "U-70",
        "위험도": "중",
        "진단 항목": "expn, vrfy 명령어 제한",
        "진단 결과": "양호",  # Assume "Good" until proven otherwise
        "현황": "SMTP 서비스 미사용 또는 noexpn, novrfy 옵션이 설정되어 있습니다.",
        "대응방안": "SMTP 설정에서 noexpn 및 novrfy 옵션 활성화"
    }

    # Check for SMTP service
    ps_output = subprocess.run(['ps', '-ef'], stdout=subprocess.PIPE, text=True).stdout.lower()
    if 'smtp' not in ps_output and 'sendmail' not in ps_output:
        return results  # No SMTP service found

    # Find sendmail.cf files
    find_command = ['find', '/', '-name', 'sendmail.cf', '-type', 'f']
    try:
        find_result = subprocess.run(find_command, stdout=subprocess.PIPE, text=True, stderr=subprocess.DEVNULL)
        sendmailcf_files = find_result.stdout.strip().split('\n')

        if not sendmailcf_files or sendmailcf_files == ['']:
            results["진단 결과"] = "취약"
            results["현황"] = "noexpn, novrfy 또는 goaway 옵션을 설정하는 파일이 없습니다."
            return results

        # Check for noexpn, novrfy, or goaway in sendmail.cf files
        for file_path in sendmailcf_files:
            with open(file_path, 'r') as file:
                content = file.read()
                if not re.search(r'PrivacyOptions.*noexpn', content, re.IGNORECASE) or not re.search(r'PrivacyOptions.*novrfy', content, re.IGNORECASE):
                    if not re.search(r'PrivacyOptions.*goaway', content, re.IGNORECASE):
                        results["진단 결과"] = "취약"
                        results["현황"] = f"{file_path} 파일에 noexpn, novrfy 또는 goaway 설정이 없습니다."
                        return results
    except Exception as e:
        results["진단 결과"] = "취약"
        results["현황"] = "SMTP 설정 파일 검사 중 오류 발생: " + str(e)
        return results

    return results

def main():
    smtp_restriction_check_results = check_smtp_restrictions()
    print(smtp_restriction_check_results)

if __name__ == "__main__":
    main()
