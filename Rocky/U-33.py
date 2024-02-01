#!/usr/bin/python3
import subprocess
import json

def check_dns_service_status():
    results = {
        "분류": "시스템 설정",
        "코드": "U-33",
        "위험도": "상",
        "진단 항목": "DNS 보안 버전 패치 '확인 필요'",
        "진단 결과": "",
        "현황": [],
        "대응방안": "[양호]: DNS 서비스를 사용하지 않거나 주기적으로 패치를 관리하고 있는 경우\n[취약]: DNS 서비스를 사용하며 주기적으로 패치를 관리하고 있지 않는 경우"
    }

    try:
        # Check if the DNS (named) service is running
        process = subprocess.run(['pgrep', '-f', 'named'], capture_output=True, text=True, check=False)
        if process.returncode == 0:
            results["진단 결과"] = "취약"
            results["현황"].append("DNS 서비스가 실행 중입니다.")
        else:
            results["진단 결과"] = "양호"
            results["현황"].append("DNS 서비스가 실행되고 있지 않습니다.")
    except Exception as e:
        results["현황"].append(f"오류 발생: {str(e)}")

    return results

def main():
    results = check_dns_service_status()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
