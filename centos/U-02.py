#!/bin/python3

import re
import json

def check_password_complexity():
    login_defs_file = "/etc/login.defs"
    pam_file = "/etc/pam.d/system-auth"
    results = []
    pass_min_len = 8

    # login.defs 파일에서 PASS_MIN_LEN 값을 확인합니다.
    with open(login_defs_file, 'r') as file:
        for line in file:
            if line.startswith("PASS_MIN_LEN"):
                value = int(line.split()[1])
                if value >= pass_min_len:
                    results.append({
                        "코드": "U-02",
                        "진단 결과": "양호",
                        "현황": f"패스워드 최소 길이 {value}글자 설정됨",
                        "대응방안": "현재 설정 유지",
                        "결과": "정상"
                    })
                else:
                    results.append({
                        "코드": "U-02",
                        "진단 결과": "취약",
                        "현황": f"패스워드 최소 길이 {value}글자 설정됨, 권장 길이 미만",
                        "대응방안": f"패스워드 최소 길이를 {pass_min_len}글자 이상으로 설정 권장",
                        "결과": "경고"
                    })
                break

    # PAM 설정 파일에서 패스워드 복잡성 정책 확인
    expected_options = "password requisite pam_cracklib.so try_first_pass retry=3 minlen=8 lcredit=-1 ucredit=-1 dcredit=-1 ocredit=-1"
    if os.path.isfile(pam_file):
        with open(pam_file, 'r') as file:
            content = file.read()
            if re.search(re.escape(expected_options), content):
                results.append({
                    "코드": "U-02",
                    "진단 결과": "양호",
                    "현황": f"{pam_file}에 필요한 패스워드 복잡성 정책 설정됨",
                    "대응방안": "현재 설정 유지",
                    "결과": "정상"
                })
            else:
                results.append({
                    "코드": "U-02",
                    "진단 결과": "취약",
                    "현황": f"{pam_file}에 필요한 패스워드 복잡성 정책 미설정",
                    "대응방안": "권장 패스워드 복잡성 정책 적용 권장",
                    "결과": "경고"
                })
    else:
        results.append({
            "코드": "U-02",
            "진단 결과": "정보",
            "현황": f"{pam_file} 파일을 찾을 수 없음",
            "대응방안": "패스워드 복잡성 정책 적용을 위해 PAM 설정 확인 권장",
            "결과": "정보"
        })

    return results

def save_results_to_json(results, file_path):
    with open(file_path, 'w') as f:
        json.dump(results, f, ensure_ascii=False, indent=4)

def main():
    results = check_password_complexity()
    save_results_to_json(results, "password_complexity_check_result.json")
        print("패스워드 복잡성 설정 점검 결과를 password_complexity_check_result.json 파일에 저장하였습니다.")

if __name__ == "__main__":
    main()

