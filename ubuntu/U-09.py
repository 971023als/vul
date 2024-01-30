import os
import stat
import json

# 결과를 저장할 딕셔너리
results = {
    "U-09": {
        "title": "/etc/hosts 파일 소유자 및 권한 설정",
        "status": "",
        "description": {
            "good": "/etc/hosts 파일의 소유자가 root이고, 권한이 600 이하인 경우",
            "bad": "/etc/hosts 파일의 소유자가 root가 아니거나, 권한이 600 이상인 경우"
        },
        "message": ""
    }
}

def check_hosts_file_ownership_and_permissions():
    hosts_file = "/etc/hosts"
    try:
        file_stat = os.stat(hosts_file)
        # 파일 소유자 확인
        if file_stat.st_uid == 0:  # UID 0은 root를 의미합니다.
            results["U-09"]["message"] += f"{hosts_file}의 소유자는 루트입니다. "
        else:
            results["U-09"]["status"] = "취약"
            results["U-09"]["message"] += f"{hosts_file}의 소유자가 루트가 아닙니다. "

        # 파일 권한 확인 (600 이하인지)
        file_perms = oct(file_stat.st_mode & 0o777)
        if int(file_perms, 8) <= 0o600:
            results["U-09"]["message"] += f"{hosts_file}의 권한은 최소 600입니다."
        else:
            results["U-09"]["status"] = "취약"
            results["U-09"]["message"] += f"{hosts_file}의 권한이 600 미만입니다. 권한: {file_perms}"

        if "취약" not in results["U-09"]["status"]:
            results["U-09"]["status"] = "양호"

    except FileNotFoundError:
        results["U-09"]["status"] = "오류"
        results["U-09"]["message"] = f"{hosts_file} 파일을 찾을 수 없습니다."

# 검사 수행
check_hosts_file_ownership_and_permissions()

# 결과를 JSON 파일로 저장
with open('result.json', 'w', encoding='utf-8') as f:
    json.dump(results, f, ensure_ascii=False, indent=4)

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
