#!/usr/bin/env python3
import json
import re

# 결과를 저장할 딕셔너리
results = {
    "U-56": {
        "title": "UMASK 설정 관리",
        "status": "",
        "description": {
            "good": "UMASK 값이 022 이하로 설정된 경우",
            "bad": "UMASK 값이 022 이하로 설정되지 않은 경우"
        },
        "details": []
    }
}

def check_umask_setting():
    try:
        with open('/etc/profile', 'r') as file:
            content = file.read()
            
            # umask 022 설정 확인
            umask_match = re.search(r"umask\s+022", content)
            export_umask_match = re.search(r"export\s+umask", content)
            
            if umask_match:
                results["U-56"]["details"].append("umask가 /etc/profile에서 022로 설정됨")
            else:
                results["U-56"]["status"] = "취약"
                results["U-56"]["details"].append("umask가 /etc/profile에서 022로 설정되지 않음")
            
            if export_umask_match:
                results["U-56"]["details"].append("/etc/profile에서 export umask로 설정됨")
            else:
                results["U-56"]["details"].append("/etc/profile에서 export umask로 설정되지 않음")
                
            # 최종 상태 설정
            if results["U-56"]["status"] != "취약":
                results["U-56"]["status"] = "양호"
                
    except FileNotFoundError:
        results["U-56"]["status"] = "정보"
        results["U-56"]["details"].append("/etc/profile 파일을 찾을 수 없습니다.")

check_umask_setting()

# 결과 파일에 JSON 형태로 저장
result_file = 'umask_setting_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
