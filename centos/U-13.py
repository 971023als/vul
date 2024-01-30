#!/usr/bin/env python3
import json
import subprocess

# 결과를 저장할 딕셔너리
results = {
    "U-13": {
        "title": "SUID, SGID, Sticky bit 설정 파일 점검",
        "status": "",
        "description": {
            "good": "주요 파일의 권한에 SUID와 SGID에 대한 설정이 부여되어 있지 않은 경우",
            "bad": "주요 파일의 권한에 SUID와 SGID에 대한 설정이 부여되어 있는 경우"
        },
        "details": []
    }
}

def check_suid_sgid_files():
    # 시스템에서 SUID와 SGID 설정이 부여된 파일을 찾습니다.
    command = "find / -type f \( -perm -4000 -o -perm -2000 \) -exec ls -l {} \;"
    process = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    stdout, stderr = process.communicate()

    if stdout:
        results["U-13"]["status"] = "취약"
        for line in stdout.split('\n'):
            if line:
                results["U-13"]["details"].append(line)
    else:
        results["U-13"]["status"] = "양호"
        results["U-13"]["details"].append("SUID와 SGID에 대한 설정이 부여된 파일이 없습니다.")

check_suid_sgid_files()

# 결과 파일에 JSON 형태로 저장
result_file = 'suid_sgid_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
