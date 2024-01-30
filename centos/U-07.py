#!/usr/bin/env python3
import json
import os
import stat

# 결과를 저장할 딕셔너리
results = {
    "U-07": {
        "title": "/etc/passwd 파일 소유자 및 권한 설정",
        "status": "",
        "description": {
            "good": "/etc/passwd 파일의 소유자가 root이고, 권한이 644 이하인 경우",
            "bad": "/etc/passwd 파일의 소유자가 root가 아니거나, 권한이 644 이하가 아닌 경우"
        },
        "details": []
    }
}

def check_passwd_file_ownership_and_permissions():
    passwd_file = "/etc/passwd"
    
    try:
        file_stat = os.stat(passwd_file)
        owner_uid = file_stat.st_uid
        permissions = stat.S_IMODE(file_stat.st_mode)
        
        # Check if the file is owned by root
        if owner_uid == 0:
            results["U-07"]["details"].append("/etc/passwd 파일이 루트에 의해 소유됩니다.")
        else:
            results["U-07"]["status"] = "취약"
            results["U-07"]["details"].append("/etc/passwd 파일이 루트에 의해 소유되지 않습니다.")
        
        # Check if the file permissions are 644 or less
        if permissions <= 0o644:
            results["U-07"]["details"].append("/etc/passwd 파일에 644 이하의 권한이 있습니다.")
            if results["U-07"]["status"] != "취약":
                results["U-07"]["status"] = "양호"
        else:
            results["U-07"]["status"] = "취약"
            results["U-07"]["details"].append("/etc/passwd 파일에 644 초과의 권한이 있습니다.")
    except FileNotFoundError:
        results["U-07"]["details"].append(f"{passwd_file} 파일이 존재하지 않습니다.")
        results["U-07"]["status"] = "정보"

check_passwd_file_ownership_and_permissions()

# 결과 파일에 JSON 형태로 저장
result_file = 'passwd_file_ownership_and_permissions_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
