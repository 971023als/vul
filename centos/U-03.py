#!/bin/python3

import re
import json

def check_account_lock_threshold():
    system_auth_file = "/etc/pam.d/system-auth"
    results = []
    # 잠금 임계값 설정을 확인할 정규 표현식 패턴
    pam_patterns = [
        re.compile(r"auth\s+required\s+pam_tally2.so\s+deny=([0-9]+)\s+unlock_time=[0-9]+"),
        re.compile(r"auth\s+required\s+pam_faillock.so\s+deny=([0-9]+)\s+unlock_time=[0-9]+")
    ]

    try:
        with open(system_auth_file, 'r') as file:
            file_content = file.read()
            for pattern in pam_patterns:
                match = pattern.search(file_content)
                if match:
                    deny_attempts = int(match.group(1))
                    if deny_attempts <= 10:
                        results.append({
                            "코드": "U-03",
                            "진단 결과": "양호",
                            "현황": f"계정 잠금 임계값이 {deny_attempts}회로 설정됨",
                            "대응방안": "현재 설정 유지",
                            "결과": "정상"
                        })
                    else:
                        results.append({
                            "코드": "U-03",
                            "진단 결과": "취약",
                            "현황": f"계정 잠금 임계값이 {deny_attempts}회로 설정됨, 10회 이하 권장",
                            "대응방안": "계정 잠금 임계값을 10회 이하로 설정 권장",
                            "결과": "경고"
                        })
                    break
            else:  # 적절한 설정을 찾지 못한 경우
                results.append({
                    "코드": "U-03",
                    "진단 결과": "취약",
                    "현황": "계정 잠금 임계값이 설정되어 있지 않음",
                    "대응방안": "계정 잠금 임계값을 10회 이하로 설정 권장",
                    "결과": "경고"
                })
    except FileNotFoundError:
        results.append({
            "코드": "U-03",
            "진단 결과": "정보",
            "현황": f"{system_auth_file} 파일을 찾을 수 없음",
            "대응방안": "/etc/pam.d/system-auth 파일의 존재 여부 및 계정 잠금 설정 확인 필요",
            "결과": "정보"
        })

    return results

def save_results_to_json(results, file_path):
    with open(file_path, 'w') as f:
        json.dump(results, f, ensure_ascii=False, indent=4)

def main():
    results = check_account_lock_threshold()
    save_results_to_json(results, "account_lock_threshold_check_result.json")
    print("계정 잠금 임계값 설정 점검 결과를 account_lock_threshold_check_result.json 파일에 저장하였습니다.")

if __name__ == "__main__":
    main()

