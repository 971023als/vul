#!/usr/bin/env python3
import json
import subprocess
from collections import Counter

# 결과를 저장할 딕셔너리
results = {
    "U-52": {
        "title": "동일한 UID 금지",
        "status": "",
        "description": {
            "good": "동일한 UID로 설정된 사용자 계정이 존재하지 않는 경우",
            "bad": "동일한 UID로 설정된 사용자 계정이 존재하는 경우"
        },
        "details": []
    }
}

def check_duplicate_uids():
    passwd_file = "/etc/passwd"
    try:
        with open(passwd_file, 'r') as file:
            uids = [line.split(':')[2] for line in file.readlines()]
            uid_counts = Counter(uids)
            duplicate_uids = {uid: count for uid, count in uid_counts.items() if count > 1}
            
            if duplicate_uids:
                results["U-52"]["status"] = "취약"
                for uid, count in duplicate_uids.items():
                    results["U-52"]["details"].append(f"UID {uid}가 {count}개의 계정에서 사용됨.")
            else:
                results["U-52"]["status"] = "양호"
                results["U-52"]["details"].append("동일한 UID를 가진 사용자 계정이 없습니다.")
    except FileNotFoundError:
        results["U-52"]["status"] = "에러"
        results["U-52"]["details"].append(f"{passwd_file} 파일이 없습니다.")

check_duplicate_uids()

# 결과 파일에 JSON 형태로 저장
result_file = 'duplicate_uids_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
