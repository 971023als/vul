#!/bin/python3

import subprocess
import json

# 로그인이 필요하지 않은 계정 목록
non_login_users = [
    "daemon", "bin", "sys", "adm", "listen", "nobody", "nobody4",
    "noaccess", "diag", "operator", "games", "gopher"
]

# /etc/passwd 파일에서 사용자 목록을 가져옵니다
passwd_content = subprocess.check_output("cat /etc/passwd", shell=True, text=True)

# 결과 저장을 위한 리스트
results = []

# 사용자 목록을 순환하며 셸을 확인합니다
for line in passwd_content.strip().split('\n'):
    user, shell = line.split(':')[0], line.split(':')[-1]
    if user in non_login_users and shell not in ["/bin/false", "/sbin/nologin"]:
        results.append(f"WARNING: 사용자 {user}의 셸이 /bin/false 또는 /sbin/nologin으로 설정되어 있지 않습니다. 현재 셸은 {shell}입니다.")
    elif user in non_login_users:
        results.append(f"OK: 사용자 {user} 셸이 {shell}로 설정됨")

# 진단 결과 요약
summary = {
    "분류": "서비스 관리",
    "코드": "U-53",
    "위험도": "상",
    "진단 항목": "사용자 shell 점검",
    "진단 결과": "취약" if any("WARNING" in result for result in results) else "양호",
    "현황": f"{len([result for result in results if 'WARNING' in result])}개의 로그인이 필요하지 않은 계정에 적절한 셸이 부여되지 않았습니다." if any("WARNING" in result for result in results) else "모든 로그인이 필요하지 않은 계정에 적절한 셸이 부여됨",
    "대응방안": "로그인이 필요하지 않은 계정에 /bin/false 또는 /sbin/nologin 셸을 부여하십시오." if any("WARNING" in result for result in results) else "현재 설정 유지"
}

# 결과 출력
print(json.dumps(summary, ensure_ascii=False, indent=4))
for result in results:
    print(result)
