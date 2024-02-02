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
        # 초기 상태를 "양호"로 설정, 장치 파일이 아닌 파일 발견 시 업데이트 예정
        "진단 결과": "양호",
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
                # 파일이 문자 장치나 블록 장치가 아닌 경우
                non_device_files.append(item_path)

    if non_device_files:
        results["진단 결과"] = "취약"
        results["현황"] = non_device_files
    else:
        # 장치 파일이 아닌 파일이 없을 경우 "현황"에 안내 메시지 추가
        results["현황"].append("/dev 디렉터리에 존재하지 않는 device 파일이 없습니다.")

    return results

def main():
    results = check_dev_directory_for_non_device_files()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
