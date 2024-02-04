#!/usr/bin/python3
import subprocess
import json
import re

def parse_version(version_string):
    """버전 문자열을 정수 튜플로 변환합니다."""
    return tuple(map(int, version_string.split('.')))

def check_dns_security_patch():
    results = {
        "분류": "서비스 관리",
        "코드": "U-33",
        "위험도": "상",
        "진단 항목": "DNS 보안 버전 패치",
        "진단 결과": "양호",  # 초기 상태 설정
        "현황": [],
        "대응방안": "DNS 서비스 주기적 패치 관리"
    }

    minimum_version = "9.18.7"

    try:
        rpm_output = subprocess.check_output("rpm -qa | grep '^bind'", shell=True, text=True, stderr=subprocess.DEVNULL).strip()
        if rpm_output:
            version_match = re.search(r'bind-(\d+\.\d+\.\d+)', rpm_output)
            if version_match and parse_version(version_match.group(1)) < parse_version(minimum_version):
                results["진단 결과"] = "취약"
                results["현황"].append(f"BIND 버전이 최신 버전({minimum_version}) 이상이 아닙니다: {version_match.group(1)}")
            else:
                results["현황"].append(f"BIND 버전이 최신 버전({minimum_version}) 이상입니다: {version_match.group(1)}")
        else:
            results["현황"].append("DNS 서비스(BIND)가 설치되어 있지 않습니다.")
    except subprocess.CalledProcessError as e:
        results["진단 결과"] = "오류"
        results["현황"].append("BIND 버전 확인 중 오류 발생")

    return results

def main():
    results = check_dns_security_patch()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
