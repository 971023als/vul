#!/usr/bin/python3

import os
import json
import subprocess

def check_user_system_files_permission():
    results = {
        "분류": "사용자 환경 설정",
        "코드": "U-14",
        "위험도": "상",
        "진단 항목": "사용자, 시스템 시작파일 및 환경파일 소유자 및 권한 설정",
        "현황": [],
        "대응방안": "홈 디렉터리의 환경변수 파일 소유자를 확인하고 적절한 권한을 설정하세요."
    }

    env_files = [".profile", ".kshrc", ".cshrc", ".bashrc", ".bash_profile", ".login", ".exrc", ".netrc"]
    home_dir = os.path.expanduser('~')

    for file in env_files:
        file_path = os.path.join(home_dir, file)
        if os.path.exists(file_path):
            owner = subprocess.getoutput(f"stat -c '%U' {file_path}")
            permission = subprocess.getoutput(f"stat -c '%a' {file_path}")
            if owner not in ["root", os.getlogin()] or permission not in ["600", "700"]:
                results["현황"].append(f"{file_path} 소유자: {owner}, 권한: {permission} (취약)")
                if "진단 결과" not in results:
                    results["진단 결과"] = "취약"
            else:
                results["현황"].append(f"{file_path} 소유자: {owner}, 권한: {permission} (양호)")
        else:
            results["현황"].append(f"{file_path} 파일이 존재하지 않습니다.")

    if "진단 결과" not in results:
        results["진단 결과"] = "양호"

    return results

def main():
    result = check_user_system_files_permission()
    print(json.dumps(result, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
