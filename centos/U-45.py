#!/usr/bin/env python3
import json
import subprocess
from pathlib import Path

# 결과를 저장할 딕셔너리
results = {
    "U-45": {
        "title": "root 계정 su 제한",
        "status": "",
        "description": {
            "good": "su 명령어를 특정 그룹에 속한 사용자만 사용하도록 제한되어 있는 경우",
            "bad": "su 명령어를 모든 사용자가 사용하도록 설정되어 있는 경우"
        },
        "details": []
    }
}

# 휠 그룹 존재 여부 검사
def check_wheel_group():
    try:
        output = subprocess.check_output(['grep', '^wheel:', '/etc/group'], text=True)
        if output:
            results["U-45"]["details"].append("휠 그룹이 존재합니다.")
        else:
            results["U-45"]["status"] = "취약"
            results["U-45"]["details"].append("휠 그룹이 존재하지 않습니다.")
    except subprocess.CalledProcessError:
        results["U-45"]["status"] = "취약"
        results["U-45"]["details"].append("휠 그룹이 존재하지 않습니다.")

# su 명령 소유권 및 권한 검사
def check_su_command():
    su_path = Path('/bin/su')
    if not su_path.exists():
        results["U-45"]["details"].append("/bin/su 파일이 존재하지 않습니다.")
        return

    # su 명령의 그룹 소유권 검사
    group = subprocess.check_output(['stat', '-c', '%G', str(su_path)], text=True).strip()
    if group != "wheel":
        results["U-45"]["status"] = "취약"
        results["U-45"]["details"].append("su 명령은 휠 그룹이 소유하지 않습니다.")
    else:
        results["U-45"]["details"].append("su 명령은 휠 그룹이 소유합니다.")

    # su 명령의 권한 검사
    permissions = subprocess.check_output(['stat', '-c', '%a', str(su_path)], text=True).strip()
    if permissions != "4750":
        results["U-45"]["status"] = "취약"
        results["U-45"]["details"].append("su 명령에 올바른 권한이 없습니다.")
    else:
        results["U-45"]["details"].append("su 명령에 올바른 권한이 있습니다.")

check_wheel_group()
check_su_command()

# 결과 파일에 JSON 형태로 저장
result_file = 'root_su_restriction_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
