#!/bin/python3

import os
import json
import glob
import stat
import pwd

# 결과를 저장할 리스트 초기화
results = []

# cron 파일 목록 정의 (glob 패턴 사용)
files = [
    "/etc/crontab", "/etc/cron.hourly", "/etc/cron.daily",
    "/etc/cron.weekly", "/etc/cron.monthly", "/etc/cron.allow",
    "/etc/cron.deny", "/var/spool/cron/*", "/var/spool/cron/crontabs/*"
]

# 파일 소유자 및 권한 검사 함수
def check_cron_file_security(files):
    checked_files = []
    for pattern in files:
        for file_path in glob.glob(pattern):
            if os.path.exists(file_path):
                stat_info = os.stat(file_path)
                owner = pwd.getpwuid(stat_info.st_uid).pw_name
                perms = oct(stat_info.st_mode & 0o777)
                if owner != "root" or int(perms, 8) > 0o640:
                    status = "취약"
                    message = f"{file_path} 소유자: {owner}, 권한: {perms} (640 이하가 아님)"
                else:
                    status = "양호"
                    message = f"{file_path} 소유자: {owner}, 권한: {perms}"
                checked_files.append({"파일": file_path, "상태": status, "메시지": message})
            else:
                checked_files.append({"파일": file_path, "상태": "정보", "메시지": f"{file_path}이 존재하지 않습니다"})
    return checked_files

# cron 파일 소유자 및 권한 검사 실행
file_results = check_cron_file_security(files)

# 결과 추가
for result in file_results:
    results.append({
        "분류": "서비스 관리",
        "코드": "U-22",
        "위험도": "상",
        "진단 항목": "cron 파일 소유자 및 권한 설정",
        "진단 결과": result["상태"],
        "현황": result["메시지"],
        "대응방안": "cron 접근 제어 파일 소유자를 root로 설정하고, 권한을 640 이하로 설정"
    })

# JSON 형태로 결과 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
