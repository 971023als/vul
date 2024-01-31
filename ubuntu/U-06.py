#!/usr/bin/python3

import subprocess
import json

def find_files_without_owners(directory):
    """
    주어진 디렉토리에서 소유자가 없는 파일 및 디렉터리를 찾습니다.
    """
    try:
        result = subprocess.check_output(['find', directory, '-nouser'], stderr=subprocess.STDOUT, text=True)
        return result.strip().split('\n') if result else []
    except subprocess.CalledProcessError as e:
        return []

def main():
    directory_to_check = "/root/"
    files_without_owners = find_files_without_owners(directory_to_check)
    
    results = {
        "분류": "파일 시스템 관리",
        "코드": "U-06",
        "위험도": "상",
        "진단 항목": "파일 및 디렉토리 소유자 설정",
        "진단 결과": "",
        "현황": [],
        "대응방안": "소유자가 존재하지 않는 파일 및 디렉터리에 적절한 소유자를 할당하세요."
    }
    
    if files_without_owners:
        results["진단 결과"] = "취약"
        results["현황"].append(f"소유자가 없는 파일 및 디렉터리가 존재합니다: {', '.join(files_without_owners)}")
    else:
        results["진단 결과"] = "양호"
        results["현황"].append("소유자가 존재하지 않은 파일 및 디렉터리가 존재하지 않습니다.")

    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
