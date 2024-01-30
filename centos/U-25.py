#!/usr/bin/env python3
import json
import re

# 결과를 저장할 딕셔너리
results = {
    "U-25": {
        "title": "NFS 서비스 접근 통제",
        "status": "",
        "description": {
            "good": "불필요한 NFS 서비스가 비활성화 되어있는 경우",
            "bad": "불필요한 NFS 서비스가 활성화 되어있는 경우"
        },
        "details": []
    }
}

def check_nfs_access_control():
    try:
        with open("/etc/exports", "r") as file:
            exports_content = file.readlines()
        
        pattern = re.compile(r'^[^#].*\severyone(?!.*no_root_squash)')
        for line in exports_content:
            if pattern.search(line):
                results["U-25"]["status"] = "취약"
                results["U-25"]["details"].append("NFS는 '모두' 그룹에 대한 제한 없이 수출을 공유하고 있습니다.")
                break
        else:
            results["U-25"]["status"] = "양호"
            results["U-25"]["details"].append("NFS는 '모두' 그룹에 대한 제한 없이 수출을 공유하지 않습니다.")
    except FileNotFoundError:
        results["U-25"]["status"] = "정보"
        results["U-25"]["details"].append("/etc/exports 파일이 존재하지 않습니다.")

check_nfs_access_control()

# 결과 파일에 JSON 형태로 저장
result_file = 'nfs_access_control_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
