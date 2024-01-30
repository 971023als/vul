import os
import stat
import json

# 결과를 저장할 딕셔너리
results = {
    "U-22": {
        "title": "cron 파일 소유자 및 권한 설정",
        "status": "",
        "description": {
            "good": "cron 접근제어 파일 소유자가 root이고, 권한이 640 이하인 경우",
            "bad": "cron 접근제어 파일 소유자가 root가 아니거나, 권한이 640 이하가 아닌 경우",
        },
        "files": []
    }
}

def check_cron_files():
    files = [
        "/etc/crontab", "/etc/cron.hourly", "/etc/cron.daily", "/etc/cron.weekly",
        "/etc/cron.monthly", "/etc/cron.allow", "/etc/cron.deny", "/var/spool/cron",
        "/var/spool/cron/crontabs/"
    ]
    
    for file_path in files:
        if os.path.exists(file_path):
            file_stat = os.stat(file_path)
            owner = stat.filemode(file_stat.st_mode)
            perms = oct(file_stat.st_mode & 0o777)
            file_info = {"file": file_path, "owner": owner, "permissions": perms}
            
            if file_stat.st_uid != 0 or int(perms, 8) > 0o640:
                results["status"] = "취약"
                results["files"].append(file_info)
            else:
                results["files"].append(file_info)
        else:
            results["files"].append({"file": file_path, "status": "Not Found"})

    if not any(file for file in results["files"] if file.get("owner") != "root" or int(file.get("permissions", "0o777"), 8) > 0o640):
        results["status"] = "양호"

# 검사 수행
check_cron_files()

# 결과를 JSON 파일로 저장
with open('result.json', 'w', encoding='utf-8') as f:
    json.dump(results, f, ensure_ascii=False, indent=4)

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
