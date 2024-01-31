#!/bin/python3

import os
import json

# 검사할 디렉터리 목록
directories = ["/home/adiosl/", "/home/cubrid/"]

# 결과 저장을 위한 리스트
results = []

# 숨겨진 파일 및 디렉터리 검사 함수
def check_hidden_items(directory):
    for root, dirs, files in os.walk(directory):
        for name in files + dirs:
            if name.startswith('.') and not name.endswith('.swp'):
                item_path = os.path.join(root, name)
                if "unwanted-file" in name or "suspicious-dir" in name:
                    results.append({
                        "status": "WARNING",
                        "path": item_path,
                        "message": f"원하지 않는 또는 의심스러운 항목 발견: {item_path}"
                    })
                else:
                    results.append({
                        "status": "OK",
                        "path": item_path,
                        "message": f"정상적인 항목: {item_path}"
                    })

# 각 디렉터리에 대해 숨겨진 항목 검사 실행
for directory in directories:
    if os.path.exists(directory):
        check_hidden_items(directory)
    else:
        results.append({
            "status": "ERROR",
            "path": directory,
            "message": f"디렉터리가 존재하지 않습니다: {directory}"
        })

# 결과 요약
summary = {
    "분류": "파일 및 디렉터리 관리 관리",
    "코드": "U-59",
    "위험도": "상",
    "진단 항목": "숨겨진 파일 및 디렉터리 검색 및 제거",
    "진단 결과": "취약" if any(result["status"] == "WARNING" for result in results) else "양호",
    "현황": f"{len([result for result in results if result['status'] == 'WARNING'])}개의 원하지 않는 또는 의심스러운 항목이 발견되었습니다." if any(result["status"] == "WARNING" for result in results) else "불필요한 파일이나 디렉터리가 발견되지 않았습니다.",
    "대응방안": "발견된 원하지 않는 또는 의심스러운 항목을 검토하고 필요한 경우 제거하세요."
}

# 결과 출력
print(json.dumps(summary, ensure_ascii=False, indent=4))
for result in results:
    print(json.dumps(result, ensure_ascii=False, indent=4))
