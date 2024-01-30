#!/usr/bin/env python3
import json
import os
import pwd

# 결과를 저장할 딕셔너리
results = {
    "U-58": {
        "title": "홈 디렉터리로 지정한 디렉터리의 존재 관리",
        "status": "",
        "description": {
            "good": "홈 디렉터리가 존재하지 않는 계정이 발견되지 않는 경우",
            "bad": "홈 디렉터리가 존재하지 않는 계정이 발견된 경우"
        },
        "details": []
    }
}

def check_home_directories_existence():
    missing_homes = []

    for user_info in pwd.getpwall():
        username = user_info.pw_name
        home_dir = user_info.pw_dir

        if not os.path.exists(home_dir):
            missing_homes.append(username)
    
    if missing_homes:
        results["U-58"]["status"] = "취약"
        results["U-58"]["details"].append(f"홈 디렉터리가 존재하지 않는 계정: {', '.join(missing_homes)}")
    else:
        results["U-58"]["status"] = "양호"
        results["U-58"]["details"].append("모든 계정에는 홈 디렉터리가 있습니다.")

check_home_directories_existence()

# 결과 파일에 JSON 형태로 저장
result_file = 'home_directory_existence_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
