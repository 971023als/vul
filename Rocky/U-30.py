#!/usr/bin/python3
import subprocess
import re
import json

def check_sendmail_version():
    results = {
        "분류": "서비스 관리",
        "코드": "U-30",
        "위험도": "상",
        "진단 항목": "Sendmail 버전 점검",
        "진단 결과": "양호",  # Assume "Good" until proven otherwise
        "현황": [],
        "대응방안": "Sendmail 버전을 최신버전으로 유지"
    }

    # Define the latest version of Sendmail for comparison
    latest_version = "8.17.1"

    try:
        # Check for Sendmail version using rpm and dnf
        rpm_version_output = subprocess.check_output("rpm -qa | grep 'sendmail'", shell=True, text=True).strip()
        dnf_version_output = subprocess.check_output("dnf list installed sendmail", shell=True, text=True).strip()

        # Extracting versions from outputs
        rpm_version = re.search(r'sendmail-(\d+\.\d+\.\d+)', rpm_version_output)
        dnf_version = re.search(r'sendmail\s+(\d+\.\d+\.\d+)', dnf_version_output)

        sendmail_version = rpm_version.group(1) if rpm_version else dnf_version.group(1) if dnf_version else ""

        # Compare found version with the latest version
        if sendmail_version.startswith(latest_version):
            results["진단 결과"] = "양호"
            results["현황"].append(f"Sendmail 버전이 최신 버전({latest_version})입니다.")
        else:
            results["진단 결과"] = "취약"
            results["현황"].append(f"Sendmail 버전이 최신 버전({latest_version})이 아닙니다. 현재 버전: {sendmail_version}")

    except subprocess.CalledProcessError as e:
        results["진단 결과"] = "오류"
        results["현황"].append(f"Sendmail 버전 확인 중 오류 발생: {e}")

    return results

def main():
    results = check_sendmail_version()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
