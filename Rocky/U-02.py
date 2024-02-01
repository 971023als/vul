#!/usr/bin/python3
import os
import re

def check_password_settings():
    results = {
        "분류": "계정 관리",  # Account Management
        "코드": "U-02",
        "위험도": "상",  # High
        "진단항목": "비밀번호 복잡성 설정",  # Password Complexity Setting
        "진단결과": "",
        "현황": [],
        "대응방안": "비밀번호 최소 길이를 최소 8자 이상으로 설정하고, 문자, 숫자, 특수 문자를 포함하도록 하세요."  # Set password minimum length to at least 8 characters, including letters, numbers, and special characters.
    }

    # 파일 존재 여부 및 설정 확인을 위한 카운터 초기화
    file_exists_count = 0
    settings_check = {
        "min_length_set": False,
        "complexity_requirement_set": False
    }

    # /etc/login.defs에서 PASS_MIN_LEN 확인
    if os.path.isfile("/etc/login.defs"):
        file_exists_count += 1
        with open("/etc/login.defs", "r") as file:
            content = file.read()
            min_len_match = re.search(r"^\s*PASS_MIN_LEN\s+(\d+)", content, re.MULTILINE)
            if min_len_match and int(min_len_match.group(1)) >= 8:
                settings_check["min_length_set"] = True

    # 비밀번호 복잡성 요구사항을 위해 /etc/pam.d/system-auth 및 /etc/pam.d/password-auth 확인
    pam_files = ["/etc/pam.d/system-auth", "/etc/pam.d/password-auth"]
    for pam_file in pam_files:
        if os.path.isfile(pam_file):
            file_exists_count += 1
            with open(pam_file, "r") as file:
                content = file.read()
                # pam_pwquality.so 또는 pam_cracklib.so가 적절한 설정으로 있는지 검색
                if re.search(r"pam_pwquality\.so", content) or re.search(r"pam_cracklib\.so", content):
                    settings_check["complexity_requirement_set"] = True

    # minlen 및 credit 설정을 위해 /etc/security/pwquality.conf 확인
    if os.path.isfile("/etc/security/pwquality.conf"):
        file_exists_count += 1
        with open("/etc/security/pwquality.conf", "r") as file:
            content = file.read()
            if re.search(r"^\s*minlen\s*=\s*(\d+)", content, re.MULTILINE) and int(min_len_match.group(1)) >= 8:
                settings_check["min_length_set"] = True
            if re.search(r"^\s*(dcredit|ucredit|ocredit|lcredit)\s*=\s*-\d+", content, re.MULTILINE):
                settings_check["complexity_requirement_set"] = True

    # 검사를 바탕으로 최종 결과 평가
    if file_exists_count > 0 and all(settings_check.values()):
        results["diagnosis_result"] = "양호"  # Good
    else:
        results["diagnosis_result"] = "취약"  # Vulnerable
        if not settings_check["min_length_set"]:
            results["status"].append("비밀번호 최소 길이 설정이 적절하게 구성되지 않았습니다.")  # Password minimum length setting is not adequately configured.
        if not settings_check["complexity_requirement_set"]:
            results["status"].append("비밀번호 복잡성 요구사항이 적절하게 구성되지 않았습니다.")  # Password complexity requirement is not adequately configured.

    return results

def main():
    results = check_password_settings()
    print(results)

if __name__ == "__main__":
    main()
