#!/bin/python3

import os
import json

def check_world_writable_files():
    results = []
    world_writable_files = []
    for root, dirs, files in os.walk("/"):
        for file in files:
            try:
                file_path = os.path.join(root, file)
                # Skip if it is a symbolic link
                if os.path.islink(file_path):
                    continue
                file_stat = os.stat(file_path)
                if file_stat.st_mode & 0o777 == 0o777:
                    world_writable_files.append(file_path)
            except Exception as e:
                # Ignoring files for which the script does not have permission to access
                continue

    if world_writable_files:
        results.append({
            "코드": "U-15",
            "진단 결과": "취약",
            "현황": "world writable 파일이 있습니다.",
            "대응방안": "world writable 파일의 존재 이유 확인 및 필요한 경우 권한 조정 권장",
            "결과": "경고"
        })
    else:
        results.append({
            "코드": "U-15",
            "진단 결과": "양호",
            "현황": "world writable 파일이 없습니다.",
            "대응방안": "현재 설정 유지",
            "결과": "정상"
        })

    return results

def save_results_to_json(results, file_path):
    with open(file_path, 'w') as f:
        json.dump(results, f, ensure_ascii=False, indent=4)

def main():
    results = check_world_writable_files()
    save_results_to_json(results, "world_writable_files_check_result.json")
    print("world writable 파일 점검 결과를 world_writable_files_check_result.json 파일에 저장하였습니다.")

if __name__ == "__main__":
    main()
