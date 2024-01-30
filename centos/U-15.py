#!/usr/bin/env python3
import json
import subprocess

# 결과를 저장할 딕셔너리
results = {
    "U-15": {
        "title": "world writable 파일 점검",
        "status": "",
        "description": {
            "good": "world writable 파일이 존재하지 않거나, 존재 시 설정 이유를 확인하고 있는 경우",
            "bad": "world writable 파일이 존재하나 해당 설정 이유를 확인하고 있지 않은 경우"
        },
        "details": []
    }
}

def check_world_writable_files():
    try:
        # 전체 시스템에서 권한이 777인 파일 검색
        command = "find / -type f -perm -a+w -exec ls {} \;"
        process = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        stdout, stderr = process.communicate()

        if stdout:
            results["U-15"]["status"] = "취약"
            results["U-15"]["details"].append("world writable 파일이 있습니다.")
            for line in stdout.split('\n'):
                if line:
                    results["U-15"]["details"].append(line)
        else:
            results["U-15"]["status"] = "양호"
            results["U-15"]["details"].append("world writable 파일이 없습니다.")
    except subprocess.SubprocessError as e:
        results["U-15"]["details"].append(f"검사 중 오류 발생: {e}")
        results["U-15"]["status"] = "정보"

check_world_writable_files()

# 결과 파일에 JSON 형태로 저장
result_file = 'world_writable_files_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
