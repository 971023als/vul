#!/usr/bin/python3
import os
import stat
import json

def check_dev_directory_for_non_device_files():
    results = {
        "분류": "파일 및 디렉터리 관리",
        "코드": "U-16",
        "위험도": "상",
        "진단 항목": "/dev에 존재하지 않는 device 파일 점검",
        "진단 결과": "양호",  # Assume "Good" until a non-device file is found
        "현황": [],
        "대응방안": "/dev에 대한 파일 점검 후 존재하지 않은 device 파일을 제거한 경우"
    }

    dev_directory = '/dev'
    non_device_files = []

    for item in os.listdir(dev_directory):
        item_path = os.path.join(dev_directory, item)
        if os.path.isfile(item_path):
            mode = os.stat(item_path).st_mode
            if not stat.S_ISCHR(mode) and not stat.S_ISBLK(mode):
                # The file is neither a character device nor a block device
                non_device_files.append(item_path)

    if non_device_files:
        results["진단 결과"] = "취약"
        results["현황"] = non_device_files
    else:
        results["현황"].append("/dev 디렉터리에 존재하지 않는 device 파일이 없습니다.")

    return results

def main():
    results = check_dev_directory_for_non_device_files()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
