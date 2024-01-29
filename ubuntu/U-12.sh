import os
import stat
import json

# 결과를 저장할 딕셔너리
results = {
    "U-12": {
        "title": "/etc/services 파일 소유자 및 권한 설정",
        "status": "",
        "description": {
            "good": "/etc/services 파일의 소유자가 root이고, 권한이 644 이하",
            "bad": "/etc/services 파일의 소유자가 root가 아니거나, 권한이 644 이상",
        },
        "message": ""
    }
}

def check_services_file():
    services_file = "/etc/services"
    if not os.path.exists(services_file):
        results["U-12"]["status"] = "오류"
        results["U-12"]["message"] = f"{services_file} 파일이 존재하지 않습니다."
        return

    file_stat = os.stat(services_file)
    # 파일 소유자 확인
    if file_stat.st_uid == 0:  # UID 0은 root를 의미합니다.
        results["U-12"]["message"] += f"{services_file}의 소유자는 root입니다. "
    else:
        results["U-12"]["status"] = "취약"
        results["U-12"]["message"] += f"{services_file}의 소유자가 root가 아닙니다. "

    # 파일 권한 확인 (644 이하인지)
    file_perms = oct(file_stat.st_mode & 0o777)
    if int(file_perms, 8) <= 0o644:
        results["U-12"]["message"] += f"{services_file}의 권한이 644 이하입니다."
    else:
        results["U-12"]["status"] = "취약"
        results["U-12"]["message"] += f"{services_file}의 권한이 644보다 큽니다. 권한: {file_perms}"

    if "취약" not in results["U-12"]["status"]:
        results["U-12"]["status"] = "양호"

# 검사 수행
check_services_file()

# 결과를 JSON 파일로 저장
with open('result.json', 'w', encoding='utf-8') as f:
    json.dump(results, f, ensure_ascii=False, indent=4)

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
