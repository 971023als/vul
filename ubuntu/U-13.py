#!/usr/bin/python3

import subprocess
import json

# 결과를 저장할 딕셔너리
results = {
    "U-13": {
        "title": "SUID,SGID,Sticky bit 설정 파일 점검",
        "status": "",
        "description": {
            "good": "주요 파일의 권한에 SUID와 SGID에 대한 설정이 부여되어 있지 않은 경우",
            "bad": "주요 파일의 권한에 SUID와 SGID에 대한 설정이 부여되어 있는 경우",
        },
        "message": "",
        "files": []
    }
}

def check_suid_sgid():
    # SUID와 SGID 설정이 부여된 파일 찾기
    cmd = ["find", "/", "-type", "f", "(", "-perm", "-04000", "-o", "-perm", "-02000", ")", "-exec", "ls", "-l", "{}", ";"]
    result = subprocess.run(cmd, capture_output=True, text=True)

    if result.stdout:
        results["U-13"]["status"] = "취약"
        results["U-13"]["message"] = results["U-13"]["description"]["bad"]
        for line in result.stdout.splitlines():
            results["U-13"]["files"].append(line)
    else:
        results["U-13"]["status"] = "양호"
        results["U-13"]["message"] = results["U-13"]["description"]["good"]

# 검사 수행
check_suid_sgid()

# 결과를 JSON 파일로 저장
with open('result.json', 'w', encoding='utf-8') as f:
    json.dump(results, f, ensure_ascii=False, indent=4)

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
