#!/usr/bin/python3
import re
import os

def check_account_lockout_threshold():
    results = {
        "분류": "계정관리",
        "코드": "U-03",
        "위험도": "상",
        "진단 항목": "계정 잠금 임계값 설정",
        "진단 결과": "양호",
        "현황": [],
        "대응방안": "계정 잠금 임계값을 10회 이하의 값으로 설정"
    }

    deny_files = ["/etc/pam.d/system-auth", "/etc/pam.d/password-auth"]
    deny_modules = ["pam_tally2.so", "pam_faillock.so"]
    file_exists_count = 0
    deny_file_exists_count = 0
    no_settings_in_deny_file = 0

    for deny_file in deny_files:
        if os.path.exists(deny_file):
            file_exists_count += 1
            with open(deny_file, 'r') as file:
                content = file.read()
                for deny_module in deny_modules:
                    deny_regex = rf"{deny_module}.*?deny=\d+"
                    matches = re.findall(deny_regex, content, re.IGNORECASE | re.MULTILINE)
                    if matches:
                        deny_file_exists_count += 1
                        for match in matches:
                            deny_value = re.search(r"deny=(\d+)", match).group(1)
                            if int(deny_value) > 10:
                                results["진단 결과"] = "취약"
                                results["현황"].append(f"{deny_file}에서 설정된 계정 잠금 임계값이 10회 이상으로 설정되어 있습니다.")
                                break
                    else:
                        no_settings_in_deny_file += 1

    if file_exists_count == 0:
        results["진단 결과"] = "취약"
        results["현황"].append("계정 잠금 임계값을 설정하는 파일이 없습니다.")
    elif deny_file_exists_count == no_settings_in_deny_file:
        results["진단 결과"] = "취약"
        results["현황"].append("계정 잠금 임계값을 설정한 파일이 없습니다.")

    return results

def main():
    results = check_account_lockout_threshold()
    print("분류:", results["분류"])
    print("코드:", results["코드"])
    print("위험도:", results["위험도"])
    print("진단 항목:", results["진단 항목"])
    print("진단 결과:", results["진단 결과"])
    for 상황 in results["현황"]:
        print("- ", 상황)
    if results["대응방안"]:
        print("대응방안:", results["대응방안"])

if __name__ == "__main__":
    main()
