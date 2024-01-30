#!/usr/bin/env python3
import json
import os
import stat

# 결과를 저장할 딕셔너리
results = {
    "U-08": {
        "title": "/etc/shadow 파일 소유자 및 권한 설정",
        "status": "",
        "description": {
            "good": "/etc/shadow 파일의 소유자가 root이고, 권한이 400인 경우",
            "bad": "/etc/shadow 파일의 소유자가 root가 아니거나, 권한이 400이 아닌 경우"
        },
        "details": []
    }
}

def check_shadow_file_ownership_and_permissions():
    shadow_file = "/etc/shadow"
    
    if os.path.exists(shadow_file):
        file_stat = os.stat(shadow_file)
        owner_uid = file_stat.st_uid
        permissions = stat.S_IMODE(file_stat.st_mode)
        
        # Check if the file is owned by root
        if owner_uid == 0:
            results["U-08"]["details"].append("/etc/shadow 파일이 루트에 의해 소유됩니다.")
        else:
            results["U-08"]["status"] = "취약"
            results["U-08"]["details"].append("/etc/shadow 파일이 루트에 의해 소유되지 않습니다.")
        
        # Check if the file permissions are exactly 400
        if permissions == 0o400:
            results["U-08"]["details"].append("/etc/shadow 파일에 400의 권한이 있습니다.")
            if results["U-08"]["status"] != "취약":
                results["U-08"]["status"] = "양호"
        else:
            results["U-08"]["status"] = "취약"
            results["U-08"]["details"].append("/etc/shadow 파일에 400이 아닌 권한이 있습니다.")
    else:
        results["U-08"]["status"] = "정보"
        results["U-08"]["details"].append("/etc/shadow 파일이 존재하지 않습니다.")

check_shadow_file_ownership_and_permissions()

# 결과 파일에 JSON 형태로 저장
result_file = 'shadow_file_ownership_and_permissions_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
