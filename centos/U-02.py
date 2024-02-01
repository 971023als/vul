#!/usr/bin/python3
import re
import json

def check_password_complexity():
    results = {
        "분류": "시스템 설정",
        "코드": "U-02",
        "위험도": "상",
        "진단 항목": "패스워드 복잡성 설정",
        "진단 결과": "",
        "현황": [],
        "대응방안": "[양호]: 영문 숫자 특수문자가 혼합된 8 글자 이상의 패스워드가 설정된 경우.\n[취약]: 영문 숫자 특수문자 혼합되지 않은 8 글자 미만의 패스워드가 설정된 경우."
    }

    login_defs_file = "/etc/login.defs"
    pam_file = "/etc/pam.d/system-auth"
    expected_options = "password requisite pam_cracklib.so try_first_pass retry=3 minlen=8 lcredit=-1 ucredit=-1 dcredit=-1 ocredit=-1"

    # Check /etc/login.defs for PASS_MIN_LEN
    try:
        with open(login_defs_file, 'r') as file:
            content = file.read()
            pass_min_len_matches = re.findall(f"{PASS_MIN_LEN_OPTION}[ \t]+([0-9]+)", content)
            highest_value = max(map(int, pass_min_len_matches)) if pass_min_len_matches else 0
            if highest_value >= 8:
                results["진단 결과"] = "양호"
                results["현황"].append("8 글자 이상의 패스워드가 설정된 경우")
            else:
                results["진단 결과"] = "취약"
                results["현황"].append("8 글자 미만의 패스워드가 설정된 경우")
    except FileNotFoundError:
        results["현황"].append(f"{login_defs_file} 파일이 존재하지 않습니다.")

    # Check /etc/pam.d/system-auth for expected options
    try:
        with open(pam_file, 'r') as file:
            content = file.read()
            if expected_options in content:
                results["진단 결과"] = "양호"
                results["현황"].append(f"{pam_file}에 {expected_options}이(가) 있습니다.")
            else:
                results["진단 결과"] = "취약"
                results["현황"].append(f"{pam_file}에 {expected_options}이(가) 없습니다.")
    except FileNotFoundError:
        results["현황"].append(f"{pam_file} 파일을 찾을 수 없습니다.")

    return results

def main():
    results = check_password_complexity()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
