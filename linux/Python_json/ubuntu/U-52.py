#!/usr/bin/python3
import os
import json
from collections import defaultdict

def check_duplicate_uids():
    results = {
        "분류": "계정관리",  # Category
        "코드": "U-52",       # Code
        "위험도": "중",        # Risk level
        "진단 항목": "동일한 UID 금지",  # Diagnostic item
        "진단 결과": "양호",  # Diagnosis result, default to "Good"
        "현황": [],           # Current status
        "대응방안": "동일한 UID로 설정된 사용자 계정을 제거하거나 수정"  # Countermeasures
    }

    # Define the minimum UID for regular (non-system) user accounts
    min_regular_user_uid = 1000

    if os.path.isfile("/etc/passwd"):
        uid_to_users = defaultdict(list)
        with open("/etc/passwd", 'r') as file:
            for line in file:
                if line.strip() and not line.startswith("#"):
                    parts = line.split(":")
                    username, uid = parts[0], parts[2]
                    if int(uid) >= min_regular_user_uid:
                        uid_to_users[uid].append(username)
            
            # Check for duplicate UIDs
            for uid, users in uid_to_users.items():
                if len(users) > 1:
                    results["진단 결과"] = "취약"
                    results["현황"].append(f"UID {uid} is shared by users: {', '.join(users)}")
                    
    else:
        results["진단 결과"] = "취약"
        results["현황"].append("/etc/passwd 파일이 없습니다.")

    return results

def main():
    duplicate_uids_check_results = check_duplicate_uids()
    print(json.dumps(duplicate_uids_check_results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
