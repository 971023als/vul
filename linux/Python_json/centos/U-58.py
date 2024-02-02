#!/usr/bin/python3
import pwd
import os
import json

def check_home_directories_existence():
    results = {
        "분류": "파일 및 디렉토리 관리",
        "코드": "U-58",
        "위험도": "중",
        "진단 항목": "홈디렉토리로 지정한 디렉토리의 존재 관리",
        "진단 결과": "양호",  # Assume "Good" until proven otherwise
        "현황": [],
        "대응방안": "홈 디렉터리가 존재하지 않는 계정이 없도록 관리"
    }

    users = pwd.getpwall()
    for user in users:
        # Skip system accounts and those with no login shell
        if user.pw_uid >= 1000 and not user.pw_shell.endswith("nologin") and not user.pw_shell.endswith("false"):
            if not os.path.exists(user.pw_dir) or user.pw_dir == "/" and user.pw_name != "root":
                results["진단 결과"] = "취약"
                if not os.path.exists(user.pw_dir):
                    results["현황"].append(f"{user.pw_name} 계정의 홈 디렉터리 ({user.pw_dir}) 가 존재하지 않습니다.")
                elif user.pw_dir == "/":
                    results["현황"].append(f"관리자 계정(root)이 아닌데 {user.pw_name} 계정의 홈 디렉터리가 '/'로 설정되어 있습니다.")

    if results["진단 결과"] == "양호":
        results["현황"].append("모든 사용자 계정의 홈 디렉터리가 적절히 설정되어 있습니다.")

    return results

def main():
    home_directory_check_results = check_home_directories_existence()
    print(home_directory_check_results)

if __name__ == "__main__":
    main()
