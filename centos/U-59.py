#!/bin/python3

import os
import json
import re

def find_hidden_files(dir_path):
    hidden_files = []
    hidden_dirs = []
    for root, dirs, files in os.walk(dir_path):
        for name in files:
            if name.startswith('.') and not name.endswith('.swp'):
                hidden_files.append(os.path.join(root, name))
        for name in dirs:
            if name.startswith('.') and not name.endswith('.swp'):
                hidden_dirs.append(os.path.join(root, name))
    return hidden_files, hidden_dirs

def evaluate_files_dirs(files_dirs):
    results = []
    for item in files_dirs:
        item_name = os.path.basename(item)
        if re.search("unwanted-file|suspicious-dir", item_name):
            results.append({
                "분류": "파일/디렉터리",
                "코드": "U-59",
                "위험도": "중",
                "진단 항목": "숨겨진 파일 및 디렉터리 검사",
                "진단 결과": "취약",
                "현황": f"원하지 않는 파일 또는 의심스러운 디렉터리: {item}",
                "대응방안": "불필요하거나 의심스러운 파일/디렉터리 삭제",
                "결과": "경고 발생"
            })
        else:
            results.append({
                "분류": "파일/디렉터리",
                "코드": "U-59",
                "위험도": "낮음",
                "진단 항목": "숨겨진 파일 및 디렉터리 검사",
                "진단 결과": "양호",
                "현황": f"정상적인 파일 또는 디렉터리: {item}",
                "대응방안": "유지",
                "결과": "정상"
            })
    return results

def save_results_to_json(results, file_path):
    with open(file_path, 'w') as f:
        json.dump(results, f, ensure_ascii=False, indent=4)

def main():
    directories = ["/home/adiosl/", "/home/cubrid/"]
    all_results = []
    
    for dir_path in directories:
        hidden_files, hidden_dirs = find_hidden_files(dir_path)
        files_results = evaluate_files_dirs(hidden_files)
        dirs_results = evaluate_files_dirs(hidden_dirs)
        all_results.extend(files_results)
        all_results.extend(dirs_results)
    
    save_results_to_json(all_results, "result.json")
    print("진단 결과를 result.json 파일에 저장하였습니다.")

if __name__ == "__main__":
    main()



 
