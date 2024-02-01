#!/usr/bin/python3
import subprocess
import json
import re

def check_dns_security_patch():
    results = {
        "분류": "서비스 관리",
        "코드": "U-33",
        "위험도": "상",
        "진단 항목": "DNS 보안 버전 패치",
        "진단 결과": "양호",  # Assume "Good" until proven otherwise
        "현황": [],
        "대응방안": "DNS 서비스 주기적 패치 관리"
    }

    # Specify the minimum acceptable version for BIND
    minimum_version = "9.18.7"

    try:
        # Checking BIND version using rpm and dnf
        rpm_output = subprocess.check_output("rpm -qa | grep '^bind'", shell=True, text=True, stderr=subprocess.DEVNULL).strip()
        dnf_output = subprocess.check_output("dnf list installed bind*", shell=True, text=True, stderr=subprocess.DEVNULL).strip()

        # Extract version numbers
        rpm_versions = re.findall(r'bind-9\.(\d+\.\d+)', rpm_output)
        dnf_versions = re.findall(r'bind-9\.(\d+\.\d+)', dnf_output)

        # Combine versions from both commands
        versions = rpm_versions + dnf_versions

        if not versions:
            results["진단 결과"] = "양호"
            results["현황"].append("DNS 서비스(BIND)가 설치되어 있지 않습니다.")
        else:
            vulnerable = True
            for version in versions:
                if version >= minimum_version.replace("9.", ""):
                    vulnerable = False
                    break

            if vulnerable:
                results["진단 결과"] = "취약"
                results["현황"].append(f"BIND 버전이 최신 버전({minimum_version}) 이상이 아닙니다.")
            else:
                results["현황"].append(f"BIND 버전이 최신 버전({minimum_version}) 이상입니다.")

    except subprocess.CalledProcessError as e:
        results["진단 결과"] = "오류"
        results["현황"].append(f"BIND 버전 확인 중 오류 발생: {e}")

    return results

def main():
    results = check_dns_security_patch()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
