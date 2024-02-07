#!/usr/bin/python3
import os
import json
from collections import Counter

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
        with open("/etc/passwd", 'r') as file:
            # Filter out system accounts and extract UIDs for regular users
            uids = [
                line.split(":")[2] for line in file 
                if line.strip() and not line.startswith("#") 
                and int(line.split(":")[2]) >= min_regular_user_uid
            ]
            
            # Count occurrences of each UID
            uid_counts = Counter(uids)
            
            # Find UIDs that occur more than once
            duplicate_uids = {uid: count for uid, count in uid_counts.items() if count > 1}

            # If duplicates are found, mark the result as "vulnerable"
            if duplicate_uids:
                results["진단 결과"] = "취약"
                duplicates_formatted = ", ".join([f"UID {uid} ({count}x)" for uid, count in duplicate_uids.items()])
                results["현황"].append(f"동일한 UID로 설정된 사용자 계정이 존재합니다: {duplicates_formatted}")
    else:
        # If the /etc/passwd file is missing, mark the result as "vulnerable"
        results["진단 결과"] = "취약"
        results["현황"].append("/etc/passwd 파일이 없습니다.")

    return results

def main():
    # Run the UID check and print results in JSON format
    duplicate_uids_check_results = check_duplicate_uids()
    print(json.dumps(duplicate_uids_check_results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
