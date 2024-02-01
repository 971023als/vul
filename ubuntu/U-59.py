#!/usr/bin/python3
import os
import json

def check_hidden_files_and_directories(rootdir="/home/user/"):
    results = {
        "분류": "시스템 설정",
        "코드": "U-59",
        "위험도": "상",
        "진단 항목": "숨겨진 파일 및 디렉터리 검색 및 제거",
        "진단 결과": "",
        "현황": [],
        "대응방안": "[양호]: 디렉터리 내 숨겨진 파일을 확인하여, 불필요한 파일 삭제를 완료한 경우\n[취약]: 디렉터리 내 숨겨진 파일을 확인하지 않고, 불필요한 파일을 방치한 경우"
    }

    unwanted_file_pattern = "unwanted-file"
    suspicious_dir_pattern = "suspicious-dir"

    for root, dirs, files in os.walk(rootdir):
        for name in files + dirs:
            if name.startswith('.'):
                full_path = os.path.join(root, name)
                if unwanted_file_pattern in name:
                    results["현황"].append(f"WARN: 원하지 않는 파일: {full_path}")
                elif suspicious_dir_pattern in name:
                    results["현황"].append(f"WARN: 의심스러운 디렉터리: {full_path}")
                else:
                    results["현황"].append(f"OK: 정상적인 항목: {full_path}")

    if "WARN" not in [status.split(':')[0] for status in results["현황"]]:
        results["진단 결과"] = "양호"
    else:
        results["진단 결과"] = "취약"

    return results

def main():
    results = check_hidden_files_and_directories()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
