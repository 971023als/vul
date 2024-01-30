#!/usr/bin/python3

import subprocess
import json

# 결과를 저장할 딕셔너리
results = {
    "U-15": {
        "title": "world writable 파일 점검",
        "status": "",
        "description": {
            "good": "world writable 파일이 존재하지 않거나, 존재 시 설정 이유를 확인하고 있는 경우",
            "bad": "world writable 파일이 존재하나 해당 설정 이유를 확인하고 있지 않은 경우",
        },
        "files": []
    }
}

def check_world_writable_files():
    try:
        # world writable 파일 찾기
        cmd = ["find", "/", "-type", "f", "-perm", "-777"]
        result = subprocess.run(cmd, capture_output=True, text=True, shell=False)

        if result.stdout:
            results["U-15"]["status"] = "취약"
            results["U-15"]["message"] = results["U-15"]["description"]["bad"]
            for line in result.stdout.splitlines():
                results["U-15"]["files"].append(line)
        else:
            results["U-15"]["status"] = "양호"
            results["U-15"]["message"] = results["U-15"]["description"]["good"]
    except Exception as e:
        results["U-15"]["status"] = "오류"
        results["U-15"]["message"] = str(e)

# 검사 수행
check_world_writable_files()

# 결과를 JSON 파일로 저장
with open('result.json', 'w', encoding='utf-8') as f:
    json.dump(results, f, ensure_ascii=False, indent=4)

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
