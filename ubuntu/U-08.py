#!/usr/bin/python3

import os
import stat
import json

# 결과를 저장할 딕셔너리
results = {
    "U-08": {
        "title": "/etc/shadow 파일 소유자 및 권한 설정",
        "status": "",
        "description": {
            "good": "/etc/shadow 파일의 소유자가 root이고, 권한이 400인 경우",
            "bad": "/etc/shadow 파일의 소유자가 root가 아니거나, 권한이 400이 아닌 경우"
        },
        "message": ""
    }
}

def check_shadow_file():
    shadow_file = "/etc/shadow"
    try:
        file_stat = os.stat(shadow_file)
        # 파일 소유자 확인
        if file_stat.st_uid == 0:  # UID 0은 root를 의미합니다.
            results["U-08"]["message"] += "/etc/shadow 파일이 루트에 의해 소유됩니다. "
        else:
            results["U-08"]["status"] = "취약"
            results["U-08"]["message"] += "/etc/shadow 파일이 루트에 의해 소유되지 않습니다. "

        # 파일 권한 확인 (정확히 400인지)
        file_perms = oct(file_stat.st_mode & 0o777)
        if file_perms == "0o400":
            results["U-08"]["message"] += "/etc/shadow 파일에 400의 권한이 있습니다."
        else:
            results["U-08"]["status"] = "취약"
            results["U-08"]["message"] += "/etc/shadow 파일에 400의 권한이 없습니다."

        if "취약" not in results["U-08"]["status"]:
            results["U-08"]["status"] = "양호"

    except FileNotFoundError:
        results["U-08"]["status"] = "오류"
        results["U-08"]["message"] = "/etc/shadow 파일을 찾을 수 없습니다."

# 검사 수행
check_shadow_file()

# 결과를 JSON 파일로 저장
with open('result.json', 'w', encoding='utf-8') as f:
    json.dump(results, f, ensure_ascii=False, indent=4)

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
