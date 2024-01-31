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
    for p in pwd.getpwall():
        username = p.pw_name
        home_dir = p.pw_dir
        uid = p.pw_uid
        gid = p.pw_gid
        if os.path.isdir(home_dir):
            stat_info = os.stat(home_dir)
            home_owner = pwd.getpwuid(stat_info.st_uid).pw_name
            home_group = grp.getgrgid(stat_info.st_gid).gr_name
            permissions = stat.filemode(stat_info.st_mode)
            if uid == stat_info.st_uid and not permissions[2] == "w" and not permissions[5] == "w":
                results["U-57"]["details"].append(f"{home_dir} ({username}) 소유자가 맞고 일반 사용자 쓰기 권한이 없습니다.")
            else:
                results["U-57"]["details"].append(f"{home_dir} ({username}) 소유자가 아니거나 일반 사용자 쓰기 권한이 있습니다.")
                results["U-57"]["status"] = "취약"
        else:
            results["U-57"]["details"].append(f"{home_dir} ({username}) 홈 디렉터리가 존재하지 않습니다.")
            results["U-57"]["status"] = "취약"

check_home_directories()

# 결과 파일에 JSON 형태로 저장
result_file = 'home_directory_ownership_and_permissions_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
