#!/usr/bin/python3
import os
import stat
import json

def check_world_writable_files():
    results = {
        "분류": "시스템 설정",
        "코드": "U-15",
        "위험도": "상",
        "진단 항목": "world writable 파일 점검",
        "진단 결과": "",
        "현황": [],
        "대응방안": "[양호]: world writable 파일이 존재하지 않거나, 존재 시 설정 이유를 확인하고 있는 경우\n[취약]: world writable 파일이 존재하나 해당 설정 이유를 확인하고 있지 않은 경우"
    }

    world_writable_files = []
    for root, dirs, files in os.walk("/"):
        for file in files:
            file_path = os.path.join(root, file)
            try:
                file_stat = os.stat(file_path)
                if file_stat.st_mode & stat.S_IWOTH:  # Check for world writable
                    if file_stat.st_mode & stat.S_IXOTH:  # Check for executable
                        world_writable_files.append(file_path)
            except Exception as e:
                continue  # Handle exceptions, e.g., symbolic links leading to nowhere

    if world_writable_files:
        results["진단 결과"] = "취약"
        results["현황"] += world_writable_files
    else:
        results["진단 결과"] = "양호"
        results["현황"].append("world writable 파일이 없습니다.")

    return results

def main():
    results = check_world_writable_files()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
