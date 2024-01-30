#!/usr/bin/env python3
import json
import os
import pwd
import stat

# 결과를 저장할 딕셔너리
results = {
    "U-14": {
        "title": "사용자, 시스템 시작파일 및 환경파일 소유자 및 권한 설정",
        "status": "",
        "description": {
            "good": "환경변수 파일 소유자가 root 또는 해당 계정으로 지정되어 있고, 쓰기 권한이 제한된 경우",
            "bad": "환경변수 파일 소유자가 부적절하거나 쓰기 권한이 부적절하게 설정된 경우"
        },
        "details": []
    }
}

def check_home_directory_files():
    files = [".profile", ".kshrc", ".cshrc", ".bashrc", ".bash_profile", ".login", ".exrc", ".netrc"]
    home_dir = os.path.expanduser('~')
    
    for file_name in files:
        file_path = os.path.join(home_dir, file_name)
        if os.path.isfile(file_path):
            file_stat = os.stat(file_path)
            owner = pwd.getpwuid(file_stat.st_uid).pw_name
            permissions = stat.S_IMODE(file_stat.st_mode)
            
            if owner not in ["root", os.getlogin()] or permissions not in [0o600, 0o700]:
                results["U-14"]["status"] = "취약"
                results["U-14"]["details"].append(f"{file_path}의 소유자나 권한 설정이 부적절합니다. (소유자: {owner}, 권한: {permissions})")
            else:
                results["U-14"]["details"].append(f"{file_path}의 소유자와 권한 설정이 적절합니다. (소유자: {owner}, 권한: {permissions})")
        else:
            results["U-14"]["details"].append(f"{file_path} 파일이 존재하지 않습니다.")

check_home_directory_files()

# 결과 파일에 JSON 형태로 저장
result_file = 'home_directory_files_ownership_and_permissions_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
