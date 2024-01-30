#!/usr/bin/python3

import subprocess
import json

# 결과를 저장할 딕셔너리
results = {
    "U-06": {
        "title": "파일 및 디렉토리 소유자 설정",
        "status": "",
        "description": {
            "good": "소유자가 존재하지 않은 파일 및 디렉터리가 존재하지 않는 경우",
            "bad": "소유자가 존재하지 않은 파일 및 디렉터리가 존재하는 경우"
        },
        "message": "",
        "invalid_owners": []
    }
}

def check_file_ownership():
    try:
        # 소유자가 없는 파일 및 디렉터리 검색
        cmd = ["find", "/root/", "-nouser", "-print"]
        result = subprocess.run(cmd, capture_output=True, text=True)
        if result.stdout:
            results["U-06"]["status"] = "취약"
            results["U-06"]["message"] = "소유자가 존재하지 않은 파일 및 디렉터리가 존재합니다."
            results["U-06"]["invalid_owners"] = result.stdout.splitlines()
        else:
            results["U-06"]["status"] = "양호"
            results["U-06"]["message"] = "잘못된 소유자가 있는 파일 또는 디렉터리를 찾을 수 없습니다."
    except Exception as e:
        results["U-06"]["status"] = "오류"
        results["U-06"]["message"] = str(e)

# 검사 수행
check_file_ownership()

# 결과를 JSON 파일로 저장
with open('result.json', 'w', encoding='utf-8') as f:
    json.dump(results, f, ensure_ascii=False, indent=4)

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
