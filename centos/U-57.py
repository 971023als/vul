#!/bin/python3

import subprocess
import os
import json

# 결과 저장을 위한 리스트
results = []

# /etc/passwd 파일에서 홈 디렉터리 정보 추출
try:
    passwd_content = subprocess.check_output("awk -F ':' '{print $1 \" \" $6}' /etc/passwd", shell=True, text=True)
except subprocess.CalledProcessError as e:
    results.append({
        "message": "Error reading /etc/passwd",
        "error": str(e)
    })

for line in passwd_content.strip().split('\n'):
    user, home_dir = line.split()
    if os.path.exists(home_dir):
        # 홈 디렉터리의 권한과 소유자 정보를 가져옵니다
        stat_result = os.stat(home_dir)
        permissions = stat_result.st_mode
        owner_uid = stat_result.st_uid
        
        # 해당 사용자의 UID를 가져옵니다
        user_uid = subprocess.check_output(f"id -u {user}", shell=True, text=True).strip()

        # 소유자 및 권한 검사
        if str(owner_uid) != user_uid or bool(permissions & 0o022):
            results.append({
                "user": user,
                "home_directory": home_dir,
                "status": "WARNING",
                "details": f"Home directory {home_dir} of user {user} has incorrect ownership or write permissions for other users."
            })
        else:
            results.append({
                "user": user,
                "home_directory": home_dir,
                "status": "OK",
                "details": f"Home directory {home_dir} of user {user} is properly owned by the user with no write permission for other users."
            })

# 결과 요약
summary = {
    "분류": "서비스 관리",
    "코드": "U-57",
    "위험도": "상",
    "진단 항목": "홈 디렉터리 소유자 및 권한",
    "진단 결과": "취약" if any(result["status"] == "WARNING" for result in results) else "양호",
    "현황": f"{len([result for result in results if result['status'] == 'WARNING'])}개의 홈 디렉터리가 부적절한 소유권 또는 권한을 가지고 있습니다.",
    "대응방안": "홈 디렉터리의 소유권을 올바른 사용자에게 할당하고, 다른 사용자의 쓰기 권한을 제거하세요."
}

# 결과 출력
print(json.dumps(summary, ensure_ascii=False, indent=4))
for result in results:
    print(json.dumps(result, ensure_ascii=False, indent=4))
