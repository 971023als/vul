import os
import stat
import glob
import json
import pwd

# 결과를 저장할 딕셔너리
results = {
    "U-14": {
        "title": "사용자, 시스템 시작파일 및 환경파일 소유자 및 권한 설정",
        "status": "",
        "description": {
            "good": "환경변수 파일 소유자가 root 또는 해당 계정으로 지정되어 있고 홈 디렉터리 환경변수 파일에 root와 소유자만 쓰기 권한이 부여된 경우",
            "bad": "환경변수 파일 소유자가 root 또는 해당 계정으로 지정되지 않고 홈 디렉터리 환경변수 파일에 root와 소유자 외에 쓰기 권한이 부여된 경우",
        },
        "files": []
    }
}

def check_environment_files_permissions():
    files = [".profile", ".kshrc", ".cshrc", ".bashrc", ".bash_profile", ".login", ".exrc", ".netrc"]
    home_dir = os.path.expanduser('~')
    
    for file in files:
        file_path = os.path.join(home_dir, file)
        if os.path.exists(file_path):
            file_stat = os.stat(file_path)
            file_owner = pwd.getpwuid(file_stat.st_uid).pw_name
            file_perms = stat.S_IMODE(file_stat.st_mode)
            
            if file_owner not in ["root", os.getlogin()] or file_perms not in [0o600, 0o700]:
                results["U-14"]["status"] = "취약"
                results["U-14"]["files"].append(f"{file_path}: 소유자={file_owner}, 권한={oct(file_perms)}")
            else:
                results["U-14"]["files"].append(f"{file_path}: 설정이 양호합니다.")

    if not results["U-14"]["files"]:
        results["U-14"]["status"] = "양호"
        results["U-14"]["description"] = "취약한 파일 없음"

# 검사 수행
check_environment_files_permissions()

# 결과를 JSON 파일로 저장
with open('result.json', 'w', encoding='utf-8') as f:
    json.dump(results, f, ensure_ascii=False, indent=4)

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
