#!/usr/bin/python3
import os
import json
from collections import defaultdict

def check_duplicate_uids():
    results = {
        "분류": "계정관리",
        "코드": "U-52",
        "위험도": "중",
        "진단 항목": "동일한 UID 금지",
        "진단 결과": "양호",  # 초기 상태를 "양호"로 설정
        "현황": [],
        "대응방안": "동일한 UID로 설정된 사용자 계정을 제거하거나 수정"
    }

    # 최소 UID 설정
    min_regular_user_uid = 1000

    # /etc/passwd 파일 확인
    if os.path.isfile("/etc/passwd"):
        uid_to_users = defaultdict(list)
        with open("/etc/passwd", 'r') as file:
            for line in file:
                if line.strip() and not line.startswith("#"):
                    parts = line.split(":")
                    username, uid = parts[0], parts[2]
                    if int(uid) >= min_regular_user_uid:
                        uid_to_users[uid].append(username)
            
            # 중복 UID 확인
            for uid, users in uid_to_users.items():
                if len(users) > 1:
                    results["진단 결과"] = "취약"
                    results["현황"].append({"UID": uid, "사용자": users})
                    
    else:
        results["진단 결과"] = "취약"
        results["현황"].append({"오류": "/etc/passwd 파일이 없습니다."})

    return results

def main():
    duplicate_uids_check_results = check_duplicate_uids()
    # 결과를 JSON 파일로 저장
    json_output_path = "duplicate_uids_check_results.json"
    with open(json_output_path, 'w', encoding='utf-8') as json_file:
        json.dump(duplicate_uids_check_results, json_file, ensure_ascii=False, indent=4)

    print(f"결과가 '{json_output_path}' 파일에 저장되었습니다.")

if __name__ == "__main__":
    main()
