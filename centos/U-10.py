#!/usr/bin/env python3
import json
import os
import stat

# 결과를 저장할 딕셔너리
results = {
    "U-10": {
        "title": "/etc/xinetd.conf 파일 소유자 및 권한 설정",
        "status": "",
        "description": {
            "good": "/etc/xinetd.conf 파일의 소유자가 root이고, 권한이 600인 경우",
            "bad": "/etc/xinetd.conf 파일의 소유자가 root가 아니거나, 권한이 600이 아닌 경우"
        },
        "details": []
    }
}

def check_xinetd_conf_ownership_and_permissions():
    xinetd_conf_file = "/etc/xinetd.conf"
    
    if not os.path.exists(xinetd_conf_file):
        results["U-10"]["details"].append(f"{xinetd_conf_file} 파일이 없습니다.")
        results["U-10"]["status"] = "양호"
    else:
        file_stat = os.stat(xinetd_conf_file)
        owner_uid = file_stat.st_uid
        permissions = stat.S_IMODE(file_stat.st_mode)
        
        if owner_uid == 0 and permissions == 0o600:
            results["U-10"]["status"] = "양호"
            results["U-10"]["details"].append(f"{xinetd_conf_file}의 소유자가 root이며, 권한이 600입니다.")
        else:
            results["U-10"]["status"] = "취약"
            if owner_uid != 0:
                results["U-10"]["details"].append(f"{xinetd_conf_file}가 루트에 의해 소유되지 않음")
            if permissions != 0o600:
                results["U-10"]["details"].append(f"{xinetd_conf_file}에 권한이 600이 아닙니다. 현재 권한: {permissions}")

check_xinetd_conf_ownership_and_permissions()

# 결과 파일에 JSON 형태로 저장
result_file = 'xinetd_conf_ownership_and_permissions_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
