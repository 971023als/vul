#!/usr/bin/env python3
import json
import os
import stat

# 결과를 저장할 딕셔너리
results = {
    "U-63": {
        "title": "ftpusers 파일 소유자 및 권한 설정",
        "status": "",
        "description": {
            "good": "ftpusers 파일의 소유자가 root이고, 권한이 640 이하인 경우",
            "bad": "ftpusers 파일의 소유자가 root가 아니거나, 권한이 640 이하가 아닌 경우"
        },
        "details": []
    }
}

def check_ftpusers_file():
    ftpusers_file = "/etc/vsftpd/ftpusers"
    
    if not os.path.exists(ftpusers_file):
        results["U-63"]["status"] = "정보"
        results["U-63"]["details"].append("ftpusers 파일이 없습니다. 확인해주세요.")
        return

    file_stat = os.stat(ftpusers_file)
    owner_uid = file_stat.st_uid
    permissions = stat.S_IMODE(file_stat.st_mode)
    owner = os.popen(f'stat -c "%U" {ftpusers_file}').read().strip()

    # ftpusers 파일 소유자 root 확인
    if owner == "root":
        results["U-63"]["details"].append("root가 ftpusers 파일을 소유하고 있습니다.")
    else:
        results["U-63"]["status"] = "취약"
        results["U-63"]["details"].append("root가 ftpusers 파일을 소유하고 있지 않습니다.")
    
    # ftpusers 파일에 대한 권한 확인
    if permissions > 0o640:
        results["U-63"]["status"] = "취약"
        results["U-63"]["details"].append(f"권한이 640 초과입니다: 현재 권한은 {oct(permissions)}")
    else:
        results["U-63"]["details"].append("권한이 640 이하입니다.")
        if results["U-63"]["status"] != "취약":
            results["U-63"]["status"] = "양호"

check_ftpusers_file()

# 결과 파일에 JSON 형태로 저장
result_file = 'ftpusers_file_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
