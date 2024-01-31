#!/bin/python3

import os
import json
import stat
import pwd

# 결과를 저장할 리스트 초기화
results = []

# 파일 경로 설정
equiv_file = "/etc/hosts.equiv"
rhosts_file = os.path.join(os.getenv("HOME"), ".rhosts")

# 파일 검사 함수
def check_file_security(file_path, file_owner, permission_limit):
    if os.path.isfile(file_path):
        # 소유자 확인
        owner = pwd.getpwuid(os.stat(file_path).st_uid).pw_name
        if owner != file_owner:
            return "취약", f"{file_path} 의 소유자가 {file_owner}가 아님 ({owner}이 소유)"
        # 권한 확인
        permissions = oct(stat.S_IMODE(os.lstat(file_path).st_mode))
        if int(permissions[-3:]) > permission_limit:
            return "취약", f"{file_path} 의 권한이 {permission_limit} 이하가 아님 (현재 권한: {permissions})"
        # '+' 설정 확인
        with open(file_path, 'r') as file:
            if '+' in file.read():
                return "취약", f"{file_path} 내에 '+' 설정이 있음"
        return "양호", f"{file_path} 파일이 보안 요구사항을 충족"
    else:
        return "양호", f"{file_path} 파일이 존재하지 않음"

# 파일 검사 실행
equiv_status, equiv_msg = check_file_security(equiv_file, "root", 600)
rhosts_status, rhosts_msg = check_file_security(rhosts_file, os.getenv("USER"), 600)

# 결과 추가
results.append({
    "분류": "파일 및 디렉터리 관리",
    "코드": "U-17",
    "위험도": "상",
    "진단 항목": "$HOME/.rhosts, hosts.equiv 사용 금지",
    "진단 결과": equiv_status if equiv_status == "취약" else rhosts_status,
    "현황": f"{equiv_msg}. {rhosts_msg}",
    "대응방안": "/etc/hosts.equiv 파일 및 사용자 홈 디렉터리 내 .rhosts 파일 삭제"
})

# JSON 형태로 결과 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
