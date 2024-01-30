#!/usr/bin/python3

import collections
import os

# 결과를 저장할 딕셔너리
results = {
    "U-52": {
        "title": "동일한 UID 금지",
        "status": "",
        "description": {
            "good": "동일한 UID로 설정된 사용자 계정이 존재하지 않는 경우",
            "bad": "동일한 UID로 설정된 사용자 계정이 존재하는 경우",
        },
        "details": []
    }
}

passwd_file = "/etc/passwd"

def check_duplicate_uids():
    if not os.path.exists(passwd_file):
        results["status"] = "정보"
        results["details"].append(f"{passwd_file} 파일이 없습니다.")
        return

    with open(passwd_file, 'r') as f:
        uids = [line.split(':')[2] for line in f if line.strip()]

    uid_counts = collections.Counter(uids)
    duplicate_uids = {uid: count for uid, count in uid_counts.items() if count > 1}

    if duplicate_uids:
        results["status"] = "취약"
        for uid, count in duplicate_uids.items():
            results["details"].append(f"UID {uid}가 {count}개의 계정에서 사용됨.")
    else:
        results["status"] = "양호"

check_duplicate_uids()

# 결과 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
