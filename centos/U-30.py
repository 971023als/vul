#!/usr/bin/python3
import subprocess
import json

def check_sendmail_service_and_version():
    results = {
        "분류": "시스템 설정",
        "코드": "U-30",
        "위험도": "상",
        "진단 항목": "Sendmail 버전 점검",
        "진단 결과": "",
        "현황": [],
        "대응방안": "[양호]: Sendmail 버전이 최신버전인 경우\n[취약]: Sendmail 버전이 최신버전이 아닌 경우"
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

        # Optionally, check Sendmail version
        version_process = subprocess.run(['sendmail', '-d0.1'], capture_output=True, text=True, check=False)
        if version_process.stdout:
            version_info = version_process.stdout.split('\n')[0]
            results["현황"].append(f"Sendmail 버전 정보: {version_info}")
        else:
            results["현황"].append("Sendmail 버전 정보를 가져오는데 실패했습니다.")
    except Exception as e:
        results["현황"].append(f"오류 발생: {str(e)}")

    return results

def main():
    results = check_sendmail_service_and_version()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
