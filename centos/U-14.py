#!/bin/python3

import os
import stat
import pwd
import json

def check_user_system_start_files():
    results = []
    home_dirs = [os.path.expanduser("~" + user.pw_name) for user in pwd.getpwall() if user.pw_uid >= 1000 and not user.pw_name.startswith('_')]
    files = [".profile", ".kshrc", ".cshrc", ".bashrc", ".bash_profile", ".login", ".exrc", ".netrc"]
    expected_permissions = ['600', '700']

    for home_dir in home_dirs:
        user = os.path.basename(home_dir)
        for filename in files:
            file_path = os.path.join(home_dir, filename)
            if os.path.isfile(file_path):
                owner_name = pwd.getpwuid(os.stat(file_path).st_uid).pw_name
                file_permission = oct(stat.S_IMODE(os.stat(file_path).st_mode))[-3:]

                if owner_name not in ["root", user]:
                    results.append({
                        "파일": file_path,
                        "진단 결과": "취약",
                        "소유자": owner_name,
                        "권한": file_permission,
                        "메시지": f"{filename} 파일의 소유자가 {owner_name}로 잘못 설정됨."
                    })
                elif file_permission not in expected_permissions:
                    results.append({
                        "파일": file_path,
                        "진단 결과": "취약",
                        "소유자": owner_name,
                        "권한": file_permission,
                        "메시지": f"{filename} 파일의 권한이 {file_permission}로 잘못 설정됨."
                    })
                else:
                    results.append({
                        "파일": file_path,
                        "진단 결과": "양호",
                        "소유자": owner_name,
                        "권한": file_permission,
                        "메시지": f"{filename} 파일 설정이 적절함."
                    })
            else:
                results.append({
                    "파일": file_path,
                    "진단 결과": "정보",
                    "메시지": f"{filename} 파일이 존재하지 않음."
                })

    return results

def save_results_to_json(results, file_path="user_system_start_files_check_result.json"):
    with open(file_path, 'w') as f:
        json.dump(results, f, ensure_ascii=False, indent=4)

def main():
    results = check_user_system_start_files()
    save_results_to_json(results)
    print(f"사용자 및 시스템 시작 파일 및 환경 파일 소유자 및 권한 설정 점검 결과를 {file_path} 파일에 저장하였습니다.")

if __name__ == "__main__":
    main()
