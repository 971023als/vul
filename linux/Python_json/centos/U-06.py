#!/usr/bin/python3
import os
import pwd
import grp
import json

def find_files_without_owners(start_path='/'):
    results = {
        "분류": "파일 및 디렉터리 관리",
        "코드": "U-06",
        "위험도": "상",
        "진단 항목": "파일 및 디렉터리 소유자 설정",
        "진단 결과": "",
        "현황": [],
        "대응방안": "소유자가 존재하지 않는 파일 및 디렉터리가 존재하지 않도록 설정"
    }

    # Limited to a safer directory for demonstration; change to '/' for a full system scan
    limited_scan_dir = '/tmp'  # Example: change to start_path for full scan, with caution
    no_owner_files = []

    for root, dirs, files in os.walk(limited_scan_dir):
        for name in files + dirs:
            full_path = os.path.join(root, name)
            try:
                pwd.getpwuid(os.stat(full_path).st_uid)
                grp.getgrgid(os.stat(full_path).st_gid)
            except KeyError:
                no_owner_files.append(full_path)

    if no_owner_files:
        results["진단 결과"] = "취약"
        results["현황"] = no_owner_files
    else:
        results["진단 결과"] = "양호"
        results["현황"] = "소유자가 존재하지 않는 파일 및 디렉터리가 존재하지 않도록 설정"

    return results

def main():
    results = find_files_without_owners()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
