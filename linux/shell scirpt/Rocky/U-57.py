#!/usr/bin/python3
import os
import pwd
import json

def check_home_directory_ownership_and_permissions():
    results = {
        "분류": "파일 및 디렉토리 관리",
        "코드": "U-57",
        "위험도": "중",
        "진단 항목": "홈디렉토리 소유자 및 권한 설정",
        "진단 결과": "양호",  # Assume "Good" until proven otherwise
        "현황": [],
        "대응방안": "홈 디렉터리 소유자를 해당 계정으로 설정 및 타 사용자 쓰기 권한 제거"
    }

    # Retrieve all user entries from /etc/passwd
    users = pwd.getpwall()
    vulnerable = False

    for user in users:
        home_dir = user.pw_dir
        username = user.pw_name
        # Check if the home directory exists and skip system users
        if os.path.isdir(home_dir) and user.pw_uid >= 1000:
            try:
                stat_info = os.stat(home_dir)
                # Check if the directory owner matches the user
                if stat_info.st_uid != user.pw_uid:
                    results["현황"].append(f"{home_dir} 홈 디렉터리의 소유자가 {username}이(가) 아닙니다.")
                    vulnerable = True
                else:
                    # Check for write permission for others
                    if stat_info.st_mode & 0o002:
                        results["현황"].append(f"{home_dir} 홈 디렉터리에 다른 사용자(other)의 쓰기 권한이 부여되어 있습니다.")
                        vulnerable = True
            except FileNotFoundError:
                # In case the directory is not accessible or does not exist
                pass

    if vulnerable:
        results["진단 결과"] = "취약"
    else:
        results["진단 결과"] = "양호"

    return results

def main():
    home_dir_check_results = check_home_directory_ownership_and_permissions()
    print(json.dumps(home_dir_check_results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
