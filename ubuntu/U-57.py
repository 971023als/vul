#!/usr/bin/env python3
import json
import os
import pwd
import grp
import stat

# 결과를 저장할 딕셔너리
results = {
    "U-57": {
        "title": "홈 디렉터리 소유자 및 권한",
        "status": "",
        "description": {
            "good": "홈 디렉터리 소유자가 해당 계정이고, 일반 사용자 쓰기 권한이 제거된 경우",
            "bad": "홈 디렉터리 소유자가 해당 계정이 아니고, 일반 사용자 쓰기 권한이 부여된 경우"
        },
        "details": []
    }
}

def check_home_directories():
    for user_info in pwd.getpwall():
        username, home_dir = user_info.pw_name, user_info.pw_dir
        try:
            stat_info = os.stat(home_dir)
            owner = pwd.getpwuid(stat_info.st_uid).pw_name
            group = grp.getgrgid(stat_info.st_gid).gr_name
            permissions = stat.filemode(stat_info.st_mode)
            
            # 일반 사용자 쓰기 권한 여부 확인
            if permissions[2] == 'w' or permissions[5] == 'w' or permissions[8] == 'w':
                results["U-57"]["status"] = "취약"
                results["U-57"]["details"].append(f"write 권한은 {home_dir}({owner} 및 group {group} 소유)에서 다른 사용자에게 부여됩니다.")
            else:
                results["U-57"]["details"].append(f"write 권한은 {home_dir}({owner} 및 group {group} 소유)에서 다른 사용자에게 부여되지 않습니다.")
        except FileNotFoundError:
            # 홈 디렉터리가 존재하지 않는 경우
            results["U-57"]["details"].append(f"{username}의 홈 디렉터리 {home_dir}가 존재하지 않습니다.")

    # 최종 상태 설정
    if results["U-57"]["status"] != "취약":
        results["U-57"]["status"] = "양호"

check_home_directories()

# 결과 파일에 JSON 형태로 저장
result_file = 'home_directory_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
