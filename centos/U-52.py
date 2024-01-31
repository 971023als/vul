#!/bin/python3

import subprocess
import collections
import json

# /etc/passwd 파일 경로
passwd_file = "/etc/passwd"

try:
    # /etc/passwd 파일에서 UID 목록을 추출합니다
    uid_list_output = subprocess.check_output(f"awk -F: '{{print $3}}' {passwd_file}", shell=True, text=True)
    uid_list = uid_list_output.strip().split('\n')

    # UID 별 계정 수를 세어 중복된 UID를 식별합니다
    uid_count = collections.Counter(uid_list)
    duplicate_uids = [uid for uid, count in uid_count.items() if count > 1]

    # 결과 저장을 위한 딕셔너리
    results = {
        "분류": "서비스 관리",
        "코드": "U-52",
        "위험도": "상",
        "진단 항목": "동일한 UID 금지",
        "진단 결과": "취약" if duplicate_uids else "양호",
        "현황": f"동일한 UID를 가진 사용자 계정이 있습니다: {', '.join(duplicate_uids)}" if duplicate_uids else "동일한 UID를 가진 사용자 계정이 없습니다.",
        "대응방안": "동일한 UID를 가진 사용자 계정을 수정하거나 제거하십시오." if duplicate_uids else "현재 설정 유지"
    }

except subprocess.CalledProcessError as e:
    # /etc/passwd 파일을 읽는데 실패한 경우
    results = {
        "분류": "서비스 관리",
        "코드": "U-52",
        "위험도": "정보 부족",
        "진단 항목": "동일한 UID 금지",
        "진단 결과": "정보 부족",
        "현황": f"오류: {e}",
        "대응방안": "/etc/passwd 파일의 존재와 접근 권한을 확인하십시오."
    }

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
