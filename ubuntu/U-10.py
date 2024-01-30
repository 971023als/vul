#!/usr/bin/python3

import os
import stat
import json

# 결과를 저장할 딕셔너리
results = {
    "U-10": {
        "title": "/etc/xinetd.conf 파일 소유자 및 권한 설정",
        "status": "",
        "description": {
            "good": "/etc/xinetd.conf 파일의 소유자가 root이고, 권한이 600인 경우",
            "bad": "/etc/xinetd.conf 파일의 소유자가 root가 아니거나, 권한이 600이 아닌 경우",
            "not_exists": "/etc/xinetd.conf 파일이 없습니다."
        },
        "message": ""
    }
}

def check_xinetd_conf_file():
    xinetd_conf_file = "/etc/xinetd.conf"
    if not os.path.exists(xinetd_conf_file):
        results["U-10"]["status"] = "양호"
        results["U-10"]["message"] = results["U-10"]["description"]["not_exists"]
        return

    file_stat = os.stat(xinetd_conf_file)
    # 파일 소유자 확인
    if file_stat.st_uid != 0:  # UID 0은 root를 의미합니다.
        results["U-10"]["status"] = "취약"
        results["U-10"]["message"] = results["U-10"]["description"]["bad"]
        return

    # 파일 권한 확인 (정확히 600인지)
    file_perms = oct(file_stat.st_mode & 0o777)
    if file_perms == "0o600":
        results["U-10"]["status"] = "양호"
        results["U-10"]["message"] = results["U-10"]["description"]["good"]
    else:
        results["U-10"]["status"] = "취약"
        results["U-10"]["message"] = results["U-10"]["description"]["bad"]

# 검사 수행
check_xinetd_conf_file()

# 결과를 JSON 파일로 저장
with open('result.json', 'w', encoding='utf-8') as f:
    json.dump(results, f, ensure_ascii=False, indent=4)

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
