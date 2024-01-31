#!/usr/bin/python3

import re
import os
import json

def check_password_complexity():
    # 결과 저장을 위한 딕셔너리
    results = {
        "분류": "서비스 관리",
        "코드": "U-02",
        "위험도": "상",
        "진단 항목": "패스워드 복잡성 설정",
        "현황": "",
        "대응방안": ""
    }

    # /etc/login.defs에서 PASS_MIN_LEN 값을 검사합니다.
    login_defs_file = "/etc/login.defs"
    pass_min_len_option = "PASS_MIN_LEN"
    min_length = 8

    # /etc/pam.d/common-password에서 pam_pwquality 모듈의 설정을 검사합니다.
    pam_file = "/etc/pam.d/common-password"
    expected_options = r"password\s+requisite\s+pam_pwquality\.so.*minlen=8.*"

    # /etc/login.defs 파일 검사
    try:
        with open(login_defs_file, 'r') as file:
            for line in file:
                if pass_min_len_option in line:
                    value = int(line.split()[1])
                    if value >= min_length:
                        results["현황"] += "PASS_MIN_LEN 설정이 적절합니다. "
                        break
            else:  # 해당 옵션을 찾지 못한 경우
                results["현황"] += f"{login_defs_file}에서 {pass_min_len_option} 설정을 찾을 수 없습니다. "
    except FileNotFoundError:
        results["현황"] += f"{login_defs_file} 파일을 찾을 수 없습니다. "

    # /etc/pam.d/common-password 파일 검사
    try:
        with open(pam_file, 'r') as file:
            content = file.read()
            if re.search(expected_options, content):
                results["현황"] += "PAM 설정이 적절합니다. "
            else:
                results["현황"] += f"{pam_file}에서 요구되는 PAM 설정을 찾을 수 없습니다. "
    except FileNotFoundError:
        results["현황"] += f"{pam_file} 파일을 찾을 수 없습니다. "

    # 진단 결과 결정
    if "적절합니다" in results["현황"]:
        results["진단 결과"] = "양호"
        results["대응방안"] = "현재 설정을 유지하세요."
    else:
        results["진단 결과"] = "취약"
        results["대응방안"] = "/etc/login.defs 및 /etc/pam.d/common-password 설정을 검토하고 적절히 수정하세요."

    # 결과를 JSON 파일로 저장
    with open('password_complexity_check_result.json', 'w', encoding='utf-8') as json_file:
        json.dump(results, json_file, ensure_ascii=False, indent=4)

    print("패스워드 복잡성 설정 점검 결과가 password_complexity_check_result.json 파일에 저장되었습니다.")

if __name__ == "__main__":
    check_password_complexity()
