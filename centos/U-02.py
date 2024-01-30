#!/usr/bin/env python3
import json
import re

# 결과를 저장할 딕셔너리
results = {
    "U-02": {
        "title": "패스워드 복잡성 설정",
        "status": "",
        "description": {
            "good": "영문 숫자 특수문자가 혼합된 8 글자 이상의 패스워드가 설정된 경우.",
            "bad": "영문 숫자 특수문자 혼합되지 않은 8 글자 미만의 패스워드가 설정된 경우."
        },
        "details": []
    }
}

def check_password_policy():
    login_defs_file = "/etc/login.defs"
    pam_file = "/etc/pam.d/system-auth"
    expected_options = "password requisite pam_cracklib.so try_first_pass retry=3 minlen=8 lcredit=-1 ucredit=-1 dcredit=-1 ocredit=-1"
    pass_min_len = 8

    # Check /etc/login.defs for PASS_MIN_LEN
    try:
        with open(login_defs_file, 'r') as file:
            for line in file:
                if re.match(r'^\s*PASS_MIN_LEN\s+(\d+)', line):
                    min_len = int(re.findall(r'\d+', line)[0])
                                        if min_len >= pass_min_len:
                        results["U-02"]["details"].append(f"PASS_MIN_LEN 설정이 {min_len}으로 적절히 설정되어 있습니다.")
                    else:
                        results["U-02"]["status"] = "취약"
                        results["U-02"]["details"].append("PASS_MIN_LEN 설정이 8글자 미만으로 설정되어 있습니다.")
                        break
    except FileNotFoundError:
        results["U-02"]["details"].append(f"{login_defs_file} 파일을 찾을 수 없습니다.")

    # Check /etc/pam.d/system-auth for password complexity
    try:
        with open(pam_file, 'r') as file:
            pam_content = file.read()
            if expected_options in pam_content:
                results["U-02"]["details"].append(f"{pam_file}에 패스워드 복잡성 설정이 적절히 적용되어 있습니다.")
            else:
                results["U-02"]["status"] = "취약"
                results["U-02"]["details"].append(f"{pam_file}에 패스워드 복잡성 설정이 적절히 적용되지 않았습니다.")
    except FileNotFoundError:
        results["U-02"]["details"].append(f"{pam_file} 파일을 찾을 수 없습니다.")

    # Determine overall status
    if "취약" not in results["U-02"]["status"]:
        results["U-02"]["status"] = "양호"

check_password_policy()

# 결과 파일에 JSON 형태로 저장
result_file = 'password_policy_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))

