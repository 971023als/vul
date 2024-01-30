#!/usr/bin/env python3
import json
import os

# 결과를 저장할 딕셔너리
results = {
    "U-59": {
        "title": "숨겨진 파일 및 디렉터리 검색 및 제거",
        "status": "",
        "description": {
            "good": "디렉터리 내 숨겨진 파일을 확인하여, 불필요한 파일 삭제를 완료한 경우",
            "bad": "디렉터리 내 숨겨진 파일을 확인하지 않고, 불필요한 파일을 방치한 경우"
        },
        "details": []
    }
}

def check_hidden_files_and_dirs(rootdir):
    unwanted_files = []
    suspicious_dirs = []
    
    for root, dirs, files in os.walk(rootdir):
        for file in files:
            if file.startswith(".") and not file.endswith(".swp"):
                if "unwanted-file" in file:
                    unwanted_files.append(os.path.join(root, file))
                else:
                    results["U-59"]["details"].append(f"정상적인 파일: {os.path.join(root, file)}")
        
        for dir in dirs:
            if dir.startswith(".") and not dir.endswith(".swp"):
                if "suspicious-dir" in dir:
                    suspicious_dirs.append(os.path.join(root, dir))
                else:
                    results["U-59"]["details"].append(f"정상적인 디렉터리: {os.path.join(root, dir)}")
    
    if unwanted_files or suspicious_dirs:
        results["U-59"]["status"] = "취약"
        for file in unwanted_files:
            results["U-59"]["details"].append(f"원하지 않는 파일: {file}")
        for dir in suspicious_dirs:
            results["U-59"]["details"].append(f"의심스러운 디렉터리: {dir}")
    else:
        results["U-59"]["status"] = "양호"

rootdir = "/home/user/"
check_hidden_files_and_dirs(rootdir)

# 결과 파일에 JSON 형태로 저장
result_file = 'hidden_files_and_dirs_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
