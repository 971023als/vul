#!/usr/bin/python3
import os
import subprocess
import json

def check_log_review_and_reporting():
    results = {
        "분류": "로그 관리",
        "코드": "U-43",
        "위험도": "상",
        "진단 항목": "로그의 정기적 검토 및 보고",
        "진단 결과": "",
        "현황": [],
        "대응방안": "로그 기록의 검토, 분석, 리포트 작성 및 보고 등이 정기적으로 이루어지는 경우"
    }

    # 로그 파일의 경로 정의
    log_files = {
        "utmp": "/var/log/utmp",
        "wtmp": "/var/log/wtmp",
        "btmp": "/var/log/btmp"
    }

    # 로그 파일이 있는지 확인합니다
    for log_type, log_file in log_files.items():
        if not os.path.exists(log_file):
            results["현황"].append(f"{log_type} 로그 파일({log_file})이 없습니다.")
            results["진단 결과"] = "취약"
        else:
            results["현황"].append(f"{log_type} 로그 파일({log_file})이 있습니다.")

    # 로그 파일의 검토 상태는 실제로 스크립트를 통해 자동으로 판단하기 어렵습니다
    # 여기서는 로그 파일의 존재 유무만 확인할 수 있으며, 실제 로그 검토 및 보고 과정은
    # 관리자의 정기적인 검토 및 분석에 의존합니다.

    return results

def main():
    results = check_log_review_and_reporting()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
