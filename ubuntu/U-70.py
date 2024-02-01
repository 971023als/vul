#!/usr/bin/python3
import subprocess
import json

def check_sendmail_service_and_command_restriction():
    results = {
        "분류": "시스템 설정",
        "코드": "U-70",
        "위험도": "상",
        "진단 항목": "expn, vrfy 명령어 제한",
        "진단 결과": "",
        "현황": [],
        "대응방안": "[양호]: SMTP 서비스 미사용 또는, noexpn, novrfy 옵션이 설정되어 있는 경우\n[취약]: SMTP 서비스 사용하고, noexpn, novrfy 옵션이 설정되어 있지 않는 경우"
    }

    # Sendmail 서비스가 실행 중인지 확인합니다.
    try:
        sendmail_status = subprocess.run(["systemctl", "is-active", "sendmail"], capture_output=True, text=True)
        if sendmail_status.returncode == 0:
            results["진단 결과"] = "취약"
            results["현황"].append("Sendmail 서비스가 실행 중입니다.")
        else:
            results["진단 결과"] = "양호"
            results["현황"].append("Sendmail 서비스가 실행되고 있지 않습니다.")
    except subprocess.CalledProcessError as e:
        results["현황"].append("Sendmail 서비스 상태 확인 중 오류 발생.")
    except Exception as e:
        results["현황"].append(f"예외 발생: {str(e)}")

    return results

def main():
    results = check_sendmail_service_and_command_restriction()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
