#!/bin/python3

import os
import json

def check_nonexistent_device_files():
    results = []
    nonexistent_device_files = []
    for file in os.listdir("/dev"):
        file_path = os.path.join("/dev", file)
        try:
            # Skip if it is not a regular file
            if not os.path.isfile(file_path):
                continue
            file_stat = os.stat(file_path)
            # Check for major and minor numbers being 0
            if os.major(file_stat.st_rdev) == 0 and os.minor(file_stat.st_rdev) == 0:
                nonexistent_device_files.append(file_path)
        except Exception as e:
            # Ignoring files for which the script does not have permission to access
            continue

    if nonexistent_device_files:
        results.append({
            "코드": "U-16",
            "진단 결과": "취약",
            "현황": "/dev에 존재하지 않는 device 파일이 있습니다.",
            "대응방안": "/dev에 존재하지 않는 device 파일 점검 후 제거 권장",
            "결과": "경고"
        })
    else:
        results.append({
            "코드": "U-16",
            "진단 결과": "양호",
            "현황": "/dev에 존재하지 않는 device 파일이 없습니다.",
            "대응방안": "현재 설정 유지",
            "결과": "정상"
        })

    return results

def save_results_to_json(results, file_path):
    with open(file_path, 'w') as f:
        json.dump(results, f, ensure_ascii=False, indent=4)

def main():
    results = check_nonexistent_device_files()
    save_results_to_json(results, "nonexistent_device_files_check_result.json")
    print("/dev에 존재하지 않는 device 파일 점검 결과를 nonexistent_device_files_check_result.json 파일에 저장하였습니다.")

if __name__ == "__main__":
    main()
