#!/usr/bin/python3
import os
import json

def search_and_report_hidden_files_and_directories():
    results = {
        "분류": "파일 및 디렉터리 관리",
        "코드": "U-59",
        "위험도": "상",
        "진단 항목": "숨겨진 파일 및 디렉터리 검색 및 제거",
        "진단 결과": "",
        "현황": [],
        "대응방안": "디렉터리 내 숨겨진 파일 및 디렉터리를 확인하고 불필요한 것은 삭제"
    }

    hidden_files = []
    hidden_dirs = []

    for root, dirs, files in os.walk("/"):
        for name in files:
            if name.startswith('.'):
                hidden_files.append(os.path.join(root, name))
        for name in dirs:
            if name.startswith('.'):
                hidden_dirs.append(os.path.join(root, name))

    if hidden_files:
        results["현황"].append(f"숨겨진 파일이 {len(hidden_files)}개 있습니다.")
        results["진단 결과"] = "취약"
    if hidden_dirs:
        results["현황"].append(f"숨겨진 디렉터리가 {len(hidden_dirs)}개 있습니다.")
        results["진단 결과"] = "취약"

    if not hidden_files and not hidden_dirs:
        results["현황"].append("숨겨진 파일 또는 디렉터리가 없습니다.")
        results["진단 결과"] = "양호"

    return results

def main():
    results = search_and_report_hidden_files_and_directories()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
