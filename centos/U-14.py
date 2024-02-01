#!/usr/bin/python3
import os
import stat
import pwd
import json

def check_user_system_files_ownership_and_permissions():
    results = {
        "분류": "시스템 설정",
        "코드": "U-14",
        "위험도": "상",
        "진단 항목": "사용자, 시스템 시작파일 및 환경파일 소유자 및 권한 설정",
        "진단 결과": "",
        "현황": [],
        "대응방안": "[양호]: 홈 디렉터리 환경변수 파일 소유자가 root 또는 해당 계정으로 지정되어 있고 홈 디렉터리 환경변수 파일에 root와 소유자만 쓰기 권한이 부여된 경우\n[취약]: 홈 디렉터리 환경변수 파일 소유자가 root 또는 해당 계정으로 지정되지 않고 홈 디렉터리 환경변수 파일에 root와 소유자 외에 쓰기 권한이 부여된 경우"
    }

    files = [".profile", ".kshrc", ".cshrc", ".bashrc", ".bash_profile", ".login", ".exrc", ".netrc"]
    user_home_dirs = [pwd.getpwnam(user).pw_dir for user in pwd.getpwall() if user.pw_uid >= 1000 and user.pw_shell != "/sbin/nologin"]

    for user_dir in user_home_dirs:
        for file_name in files:
            file_path = os.path.join(user_dir, file_name)
            if os.path.exists(file_path):
                file_stat = os.stat(file_path)
                owner = pwd.getpwuid(file_stat.st_uid).pw_name
                permission = oct(file_stat.st_mode)[-3:]

                if owner not in ['root', os.path.basename(user_dir)] or int(permission) not in [600, 700]:
                    results["현황"].append(f"{file_path}에 잘못된 소유자({owner}) 또는 권한({permission})이 있습니다.")
                    results["진단 결과"] = "취약"
                else:
                    results["현황"].append(f"{file_path}는 올바른 소유자({owner}) 및 권한({permission})을 가지고 있습니다.")
    
    if "진단 결과" not in results:
        results["진단 결과"] = "양호"

    return results

def main():
    results = check_user_system_files_ownership_and_permissions()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
