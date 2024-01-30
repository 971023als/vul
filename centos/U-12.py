#!/usr/bin/env python3
import json
import os
import stat

# 결과를 저장할 딕셔너리
results = {
    "U-12": {
        "title": "/etc/services 파일 소유자 및 권한 설정",
        "status": "",
        "description": {
            "good": "/etc/services 파일의 소유자가 root이고, 권한이 644인 경우",
            "bad": "/etc/services 파일의 소유자가 root가 아니거나, 권한이 644가 아닌 경우"
        },
        "details": []
    }
}

def check_services_file_ownership_and_permissions():
    services_file = "/etc/services"
    
    if os.path.exists(services_file):
        file_stat = os.stat(services_file)
        owner = os.popen(f'stat -c "%U" {services_file}').read().strip()
        permissions = stat.S_IMODE(file_stat.st_mode)
        
        if owner != "root":
            results["U-12"]["status"] = "취약"
            results["U-12"]["details"].append(f"/etc/services 파일의 소유자가 {owner}로, root가 아닙니다.")
        else:
            results["U-12"]["details"].append("/etc/services 파일이 root에 의해 소유됩니다.")
            
        if permissions > 0o644:
            results["U-12"]["status"] = "취약"
            results["U-12"]["details"].append(f"/etc/services 파일 사용 권한이 644보다 큽니다. 현재 권한: {permissions}")
        else:
            results["U-12"]["details"].append("/etc/services 파일은 644 이하의 권한이 있습니다.")
            if results["U-12"]["status"] != "취약":
                results["U-12"]["status"] = "양호"
    else:
        results["U-12"]["status"] = "정보"
        results["U-12"]["details"].append("/etc/services 파일이 없습니다.")

check_services_file_ownership_and_permissions()

# 결과 파일에 JSON 형태로 저장
result_file = 'services_file_ownership_and_permissions_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
