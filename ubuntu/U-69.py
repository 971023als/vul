#!/usr/bin/env python3
import json
import os
import stat

# 결과를 저장할 딕셔너리
results = {
    "U-69": {
        "title": "NFS 설정파일 접근권한",
        "status": "",
        "description": {
            "good": "NFS 접근제어 설정파일의 소유자가 root 이고, 권한이 644 이하인 경우",
            "bad": "NFS 접근제어 설정파일의 소유자가 root 가 아니거나, 권한이 644 초과인 경우"
        },
        "details": []
    }
}

def check_nfs_config_permissions():
    filename = "/etc/exports"

    if not os.path.exists(filename):
        results["U-69"]["details"].append(f"{filename} 가 존재하지 않습니다")
        results["U-69"]["status"] = "정보"
        return

    file_stat = os.stat(filename)
    owner_uid = file_stat.st_uid
    permissions = stat.S_IMODE(file_stat.st_mode)
    owner = os.popen(f'stat -c "%U" {filename}').read().strip()

    if owner != "root":
        results["U-69"]["status"] = "취약"
        results["U-69"]["details"].append(f"{filename}의 소유자가 루트가 아닙니다.")
    else:
        results["U-69"]["details"].append(f"{filename}의 소유자가 루트가 맞습니다.")

    if permissions > 0o644:
        results["U-69"]["status"] = "취약"
        results["U-69"]["details"].append(f"{filename}의 권한이 644보다 큽니다.")
    else:
        results["U-69"]["details"].append(f"{filename}의 권한이 644 이하입니다.")
        if results["U-69"]["status"] != "취약":
            results["U-69"]["status"] = "양호"

check_nfs_config_permissions()

# 결과 파일에 JSON 형태로 저장
result_file = 'nfs_config_permissions_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
