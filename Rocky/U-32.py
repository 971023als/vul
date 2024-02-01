#!/usr/bin/python3
import subprocess
import json

def check_sendmail_service_and_user_restriction():
    results = {
        "분류": "시스템 설정",
        "코드": "U-32",
        "위험도": "상",
        "진단 항목": "일반사용자의 Sendmail 실행 방지",
        "진단 결과": "",
        "현황": [],
        "대응방안": "[양호]: SMTP 서비스 미사용 또는, 일반 사용자의 Sendmail 실행 방지가 설정된 경우\n[취약]: SMTP 서비스 사용 및 일반 사용자의 Sendmail 실행 방지가 설정되어 있지 않은 경우"
    }

    try:
        # Check if Sendmail service is running
        process = subprocess.run(['pgrep', '-f', 'sendmail'], capture_output=True, text=True, check=False)
        if process.returncode == 0:
            results["진단 결과"] = "취약"
            results["현황"].append("Sendmail 서비스가 실행 중입니다.")
        else:
            results["진단 결과"] = "양호"
            results["현황"].append("Sendmail 서비스가 실행되고 있지 않습니다.")

        # Optionally, check for user restriction settings
        # This part is simplified and does not check the actual configuration.
        # You should add logic to check /etc/mail/sendmail.cf or other relevant files for user restrictions.
    except Exception as e:
        results["현황"].append(f"오류 발생: {str(e)}")

    return results

def main():
    results = check_sendmail_service_and_user_restriction()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
