#!/bin/python3

import os
import json

def check_system_logging_configuration():
    results = []
    # 로그 파일 위치 정의
    log_files = [
        "/var/log/secure",
        "/var/log/messages",
        "/var/log/audit/audit.log",
        "/var/log/httpd/access_log",
        "/var/log/httpd/error_log"
    ]

    # 로그 구성 파일 위치 정의
    conf_files = [
        "/etc/rsyslog.conf",
        "/etc/httpd/conf/httpd.conf",
        "/etc/audit/auditd.conf"
    ]

    # 로그 파일이 있는지 확인
    for file in log_files:
        if os.path.isfile(file):
            result_status = "양호"
            message = f"{file} 이(가) 존재합니다."
        else:
            result_status = "취약"
            message = f"{file} 이(가) 존재하지 않습니다."
        
        results.append({
            "분류": "시스템 로깅",
            "코드": "U-72",
            "위험도": "높음" if result_status == "취약" else "낮음",
            "진단 항목": "정책에 따른 시스템 로깅 설정",
            "진단 결과": result_status,
            "현황": message,
            "대응방안": "누락된 로그 파일 생성 및 관련 설정 조정",
            "결과": "경고" if result_status == "취약" else "정상"
        })

    # 로그 구성 파일이 있는지 확인
    for file in conf_files:
        if os.path.isfile(file):
            result_status = "양호"
            message = f"{file} 이(가) 존재합니다."
        else:
            result_status = "취약"
            message = f"{file} 이(가) 존재하지 않습니다."
        
        results.append({
            "분류": "시스템 로깅",
            "코드": "U-72",
            "위험도": "높음" if result_status == "취약" else "낮음",
            "진단 항목": "정책에 따른 시스템 로깅 설정",
            "진단 결과": result_status,
            "현황": message,
            "대응방안": "누락된 로그 구성 파일 생성 및 관련 설정 조정",
            "결과": "경고" if result_status == "취약" else "정상"
        })

    return results

def save_results_to_json(results, file_path):
    with open(file_path, 'w') as f:
        json.dump(results, f, ensure_ascii=False, indent=4)

def main():
    results = check_system_logging_configuration()
    save_results_to_json(results, "system_logging_configuration_check_result.json")
    print("정책에 따른 시스템 로깅 설정 점검 결과를 system_logging_configuration_check_result.json 파일에 저장하였습니다.")

if __name__ == "__main__":
    main()
