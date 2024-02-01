#!/usr/bin/python3
import pwd
import os
import json

def check_home_directory_existence():
    results = {
        "분류": "시스템 설정",
        "코드": "U-58",
        "위험도": "상",
        "진단 항목": "홈 디렉터리로 지정한 디렉터리의 존재 관리",
        "진단 결과": "",
        "현황": [],
        "대응방안": "[양호]: 홈 디렉터리가 존재하지 않는 계정이 발견되지 않는 경우\n[취약]: 홈 디렉터리가 존재하지 않는 계정이 발견된 경우"
    }

    missing_home_directories = []
    for user_info in pwd.getpwall():
        username = user_info.pw_name
        home_dir = user_info.pw_dir
        # 홈 디렉터리가 실제로 존재하는지 확인
        if not os.path.exists(home_dir):
            missing_home_directories.append(username)

    if missing_home_directories:
        results["진단 결과"] = "취약"
        results["현황"].append(f"홈 디렉터리가 존재하지 않는 계정이 발견됨: {', '.join(missing_home_directories)}")
    else:
        results["진단 결과"] = "양호"
        results["현황"].append("모든 계정에는 홈 디렉터리가 있습니다")

    return results

def main():
    results = check_home_directory_existence()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
