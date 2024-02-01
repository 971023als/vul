#!/usr/bin/python3
import os
import json

def check_root_path_security():
    results = {
        "분류": "시스템 설정",
        "코드": "U-05",
        "위험도": "상",
        "진단 항목": "root 홈, 패스 디렉토리 권한 및 패스 설정",
        "진단 결과": "",
        "현황": [],
        "대응방안": "[양호]: PATH 환경변수에 '.' 이 맨 앞이나 중간에 포함되지 않은 경우\n[취약]: PATH 환경변수에 '.' 이 맨 앞이나 중간에 포함되어 있는 경우"
    }

    path_env = os.environ.get("PATH", "")
    if path_env.startswith(".:"):
        results["진단 결과"] = "취약"
        results["현황"].append("PATH 변수의 시작 부분에서 '.' 발견됨.")
    else:
        results["현황"].append("PATH 변수의 시작 부분에서 '.' 발견 안 됨.")

    if " :." in path_env:
        results["진단 결과"] = "취약"
        results["현황"].append("PATH 변수의 중간 부분에서 '.' 발견됨.")
    else:
        if "진단 결과" not in results:
            results["진단 결과"] = "양호"
            results["현황"].append("PATH 변수의 중간 부분에서 '.' 발견 안 됨.")

    return results

def main():
    results = check_root_path_security()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
