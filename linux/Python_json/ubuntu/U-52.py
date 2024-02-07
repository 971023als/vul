#!/usr/bin/python3
import os
import json

def check_duplicate_uids():
    results = {
        "분류": "계정관리",
        "코드": "U-52",
        "위험도": "중",
        "진단 항목": "동일한 UID 금지",
        "진단 결과": "양호",
        "현황": [],
        "대응방안": "동일한 UID로 설정된 사용자 계정을 제거하거나 수정"
    }

    passwd_file = "/etc/passwd"
    uid_list = []

    if os.path.isfile(passwd_file):
        with open(passwd_file, 'r') as file:
            for line in file:
                if line.strip() and not line.startswith("#"):
                    parts = line.split(":")
                    uid = parts[2]
                    uid_list.append(uid)
        
        # 중복 UID 찾기
        uid_set = set(uid_list)
        if len(uid_list) == len(uid_set):
            results["현황"].append("모든 사용자 계정이 고유한 UID를 가지고 있습니다.")
        else:
            results["진단 결과"] = "취약"
            for uid in uid_set:
                if uid_list.count(uid) > 1:
                    results["현황"].append(f"UID {uid}는 중복됩니다.")
    else:
        results["진단 결과"] = "취약"
        results["현황"].append({"오류": "/etc/passwd 파일이 없습니다."})

    return results

def main():
    duplicate_uids_check_results = check_duplicate_uids()
    with open("duplicate_uids_check_results.json", 'w', encoding='utf-8') as json_file:
        json.dump(duplicate_uids_check_results, json_file, ensure_ascii=False, indent=4)

    print(f"결과가 'duplicate_uids_check_results.json' 파일에 저장되었습니다.")

if __name__ == "__main__":
    main()
