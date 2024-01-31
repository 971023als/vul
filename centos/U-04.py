#!/bin/python3

import json

def check_password_files_protection():
    shadow_file = "/etc/shadow"
    passwd_file = "/etc/passwd"
    results = []

    try:
        # /etc/shadow 파일 존재 여부 확인
        with open(shadow_file, 'r') as file:
            # /etc/passwd 파일에서 패스워드 필드 확인
            with open(passwd_file, 'r') as passwd:
                passwd_entries = passwd.readlines()
                unprotected_passwords = [entry for entry in passwd_entries if ":" in entry and not entry.split(":")[1].strip() in ['x', '*']]
                
                if not unprotected_passwords:
                    results.append({
                        "코드": "U-04",
                        "진단 결과": "양호",
                        "현황": "쉐도우 패스워드 사용 및 패스워드 암호화 저장 적용됨",
                        "대응방안": "현재 설정 유지",
                        "결과": "정상"
                    })
                else:
                    results.append({
                        "코드": "U-04",
                        "진단 결과": "취약",
                        "현황": "쉐도우 패스워드 미사용, 일부 패스워드 암호화 미적용",
                        "대응방안": "쉐도우 패스워드 사용 및 모든 패스워드 암호화 저장 적용 권장",
                        "결과": "경고"
                    })
    except FileNotFoundError as e:
        # 파일 미존재시 결과 추가
        missing_file = str(e).split("No such file or directory: ")[1]
        results.append({
            "코드": "U-04",
            "진단 결과": "정보",
            "현황": f"{missing_file} 파일을 찾을 수 없음",
            "대응방안": "/etc/shadow 및 /etc/passwd 파일의 존재 여부 및 설정 확인 필요",
            "결과": "정보"
        })

    return results

def save_results_to_json(results, file_path):
    with open(file_path, 'w') as f:
        json.dump(results, f, ensure_ascii=False, indent=4)

def main():
    results = check_password_files_protection()
    save_results_to_json(results, "password_files_protection_check_result.json")
    print("패스워드 파일 보호 설정 점검 결과를 password_files_protection_check_result.json 파일에 저장하였습니다.")

if __name__ == "__main__":
    main()
