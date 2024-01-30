import subprocess
import os
import json

# 결과를 저장할 딕셔너리
results = {
    "U-45": {
        "title": "root 계정 su 제한",
        "status": "",
        "description": {
            "good": "su 명령어를 특정 그룹에 속한 사용자만 사용하도록 제한되어 있는 경우",
            "bad": "su 명령어를 모든 사용자가 사용하도록 설정되어 있는 경우",
        },
        "details": []
    }
}

def check_su_command_restriction():
    wheel_group_exists = subprocess.run(["grep", "^wheel:", "/etc/group"], capture_output=True).returncode == 0
    su_command_group = subprocess.run(["stat", "-c", "%G", "/bin/su"], capture_output=True, text=True).stdout.strip()
    su_command_permissions = subprocess.run(["stat", "-c", "%a", "/bin/su"], capture_output=True, text=True).stdout.strip()
    
    if not wheel_group_exists:
        results["details"].append("휠 그룹이 존재하지 않습니다.")
        results["status"] = "취약"
    else:
        results["details"].append("휠 그룹이 존재합니다.")
        
    if su_command_group != "wheel":
        results["details"].append("su 명령은 휠 그룹이 소유하지 않습니다.")
        results["status"] = "취약"
    else:
        results["details"].append("su 명령은 휠 그룹이 소유합니다.")
    
    if su_command_permissions != "4750":
        results["details"].append("su 명령에 올바른 권한이 없습니다.")
        results["status"] = "취약"
    else:
        results["details"].append("su 명령에 올바른 권한이 있습니다.")

    # 휠 그룹에 속한 사용자가 있는지 확인
    wheel_group_users = subprocess.run(["grep", "^wheel:", "/etc/group"], capture_output=True, text=True).stdout.split(":")[-1].strip()
    if wheel_group_users:
        results["details"].append("휠 그룹의 어떤 계정도 su 명령을 사용할 수 있습니다.")
    else:
        results["details"].append("휠 그룹의 어떤 계정도 su 명령을 사용할 수 없습니다.")
        results["status"] = "취약"

    if not results["status"]:
        results["status"] = "양호"

# 검사 수행
check_su_command_restriction()

# 결과를 JSON 파일로 저장
with open('result.json', 'w', encoding='utf-8') as f:
    json.dump(results, f, ensure_ascii=False, indent=4)

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
