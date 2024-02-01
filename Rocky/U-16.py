#!/usr/bin/python3
import os
import stat
import json

def check_dev_device_files():
    results = {
        "분류": "시스템 설정",
        "코드": "U-16",
        "위험도": "상",
        "진단 항목": "/dev에 존재하지 않는 device 파일 점검",
        "진단 결과": "",
        "현황": [],
        "대응방안": "[양호]: dev에 대한 파일 점검 후 존재하지 않은 device 파일을 제거한 경우\n[취약]: dev에 대한 파일 미점검, 또는, 존재하지 않은 device 파일을 방치한 경우"
    }

    dev_path = '/dev'
    for root, dirs, files in os.walk(dev_path):
        for file in files:
            file_path = os.path.join(root, file)
            try:
                file_stat = os.stat(file_path)
                if stat.S_ISBLK(file_stat.st_mode) or stat.S_ISCHR(file_stat.st_mode):
                    major = os.major(file_stat.st_rdev)
                    minor = os.minor(file_stat.st_rdev)
                    if major == 0 and minor == 0:
                        results["현황"].append(f"{file_path} 메이저 및 마이너 번호가 없는 장치를 찾았습니다")
                        results["진단 결과"] = "취약"
                else:
                    continue
            except Exception as e:
                continue  # Handle exceptions, e.g., symbolic links leading to nowhere

    if not results["현황"]:
        results["진단 결과"] = "양호"
        results["현황"].append("메이저 및 마이너 번호가 없는 장치가 없습니다")

    return results

def main():
    results = check_dev_device_files()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
