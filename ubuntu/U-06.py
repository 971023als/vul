#!/usr/bin/python3
import subprocess
import json

def check_for_files_without_owners():
    results = {
        "분류": "시스템 설정",
        "코드": "U-06",
        "위험도": "상",
        "진단 항목": "파일 및 디렉토리 소유자 설정",
        "진단 결과": "",
        "현황": [],
        "대응방안": "[양호]: 소유자가 존재하지 않은 파일 및 디렉터리가 존재하지 않는 경우\n[취약]: 소유자가 존재하지 않은 파일 및 디렉터리가 존재하는 경우"
    }

    try:
        # /root 디렉토리 아래에서 소유자가 없는 파일 및 디렉터리 검색
        command = ["find", "/root/", "-nouser"]
        process = subprocess.run(command, check=True, capture_output=True, text=True)
        invalid_owner_files = process.stdout.strip()

        if invalid_owner_files:
            results["진단 결과"] = "취약"
            results["현황"].append("잘못된 소유자가 있는 파일 또는 디렉터리를 찾을 수 있습니다:")
            results["현황"].append(invalid_owner_files)
        else:
            results["진단 결과"] = "양호"
            results["현황"].append("잘못된 소유자가 있는 파일 또는 디렉터리를 찾을 수 없습니다.")
    except subprocess.CalledProcessError as e:
        results["현황"].append("파일 검색 중 오류 발생: " + str(e))

    return results

def main():
    results = check_for_files_without_owners()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
