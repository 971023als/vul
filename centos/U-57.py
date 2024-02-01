#!/usr/bin/python3
import os
import pwd
import json

def check_home_directory_permissions():
    results = {
        "분류": "시스템 설정",
        "코드": "U-57",
        "위험도": "상",
        "진단 항목": "홈 디렉터리 소유자 및 권한",
        "진단 결과": "",
        "현황": [],
        "대응방안": "[양호]: 홈 디렉터리 소유자가 해당 계정이고, 일반 사용자 쓰기 권한이 제거된 경우\n[취약]: 홈 디렉터리 소유자가 해당 계정이 아니고, 일반 사용자 쓰기 권한이 부여된 경우"
    }

    for user_info in pwd.getpwall():
        home_dir = user_info.pw_dir
        username = user_info.pw_name
        if os.path.isdir(home_dir):
            try:
                stat_info = os.stat(home_dir)
                home_dir_owner = pwd.getpwuid(stat_info.st_uid).pw_name
                permissions = stat.S_IMODE(stat_info.st_mode)
                # 일반 사용자 쓰기 권한 검사
                if home_dir_owner == username and permissions & 0o022 == 0:
                    results["현황"].append(f"OK: {home_dir}({username}) 소유자가 적절하며, 일반 사용자 쓰기 권한이 제거됨")
                else:
                    results["진단 결과"] = "취약"
                    results["현황"].append(f"WARN: {home_dir}({username})에서 소유자 불일치 또는 일반 사용자 쓰기 권한 부여")
            except KeyError:
                # UID에 대한 사용자 정보를 찾을 수 없음
                pass

    if "취약" not in results["진단 결과"]:
        results["진단 결과"] = "양호"

    return results

def main():
    results = check_home_directory_permissions()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
