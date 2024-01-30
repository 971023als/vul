import os
import pwd
import glob
import json

# 결과를 저장할 딕셔너리
results = {
    "U-17": {
        "title": "$HOME/.rhosts, hosts.equiv 사용 금지",
        "status": "",
        "description": {
            "good": "적절한 설정이 적용된 경우",
            "bad": "적절한 설정이 적용되지 않은 경우",
        },
        "details": []
    }
}

def check_file_settings(file_path):
    # 파일 존재 여부 확인
    if not os.path.exists(file_path):
        results["details"].append(f"{file_path} 파일을 찾을 수 없습니다.")
        return

    # 파일 소유자 확인
    file_stat = os.stat(file_path)
    owner_name = pwd.getpwuid(file_stat.st_uid).pw_name
    expected_owners = ['root', os.getlogin()]
    if owner_name not in expected_owners:
        results["status"] = "취약"
        results["details"].append(f"{file_path} 소유자가 {owner_name}으로, 예상되는 소유자 ({', '.join(expected_owners)})가 아닙니다.")

    # 파일 권한 확인
    file_perms = oct(file_stat.st_mode & 0o777)
    if int(file_perms, 8) > 0o600:
        results["status"] = "취약"
        results["details"].append(f"{file_path} 권한이 {file_perms}로 설정되어 있습니다. 600 이하가 예상됩니다.")

    # 파일 내용 확인
    with open(file_path, 'r') as file:
        if "+" in file.read():
            results["status"] = "취약"
            results["details"].append(f"{file_path} 내 '+' 설정이 있습니다.")
        else:
            results["details"].append(f"{file_path} 내 '+' 설정이 없습니다.")

# 검사 수행
check_file_settings("/etc/hosts.equiv")
for rhosts_file in glob.glob(os.path.join(os.path.expanduser('~'), '.rhosts')):
    check_file_settings(rhosts_file)

if not results["status"]:
    results["status"] = "양호"

# 결과를 JSON 파일로 저장
with open('result.json', 'w', encoding='utf-8') as f:
    json.dump(results, f, ensure_ascii=False, indent=4)

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
