import os
import stat
import json

# 결과를 저장할 딕셔너리
results = {
    "U-11": {
        "title": "/etc/rsyslog.conf 파일 소유자 및 권한 설정",
        "status": "",
        "description": {
            "good": "/etc/rsyslog.conf 파일의 소유자가 root(또는 bin, sys)이고, 권한이 640 이하인 경우",
            "bad": "/etc/rsyslog.conf 파일의 소유자가 root(또는 bin, sys)가 아니거나, 권한이 640 이하가 아닌 경우",
            "not_exists": "/etc/rsyslog.conf 파일이 존재하지 않습니다."
        },
        "message": ""
    }
}

def check_rsyslog_conf_file():
    rsyslog_conf_file = "/etc/rsyslog.conf"
    if not os.path.exists(rsyslog_conf_file):
        results["U-11"]["status"] = "양호"
        results["U-11"]["message"] = results["U-11"]["description"]["not_exists"]
        return

    file_stat = os.stat(rsyslog_conf_file)
    # 파일 소유자 확인
    file_owner_uid = file_stat.st_uid
    file_owner_name = stat.filemode(file_stat.st_mode)
    if file_owner_uid == 0 or file_owner_name in ['root', 'bin', 'sys']:
        # 파일 권한 확인 (640 이하인지)
        file_perms = oct(file_stat.st_mode & 0o777)
        if int(file_perms, 8) <= 0o640:
            results["U-11"]["status"] = "양호"
            results["U-11"]["message"] = results["U-11"]["description"]["good"]
        else:
            results["U-11"]["status"] = "취약"
            results["U-11"]["message"] = results["U-11"]["description"]["bad"]
    else:
        results["U-11"]["status"] = "취약"
        results["U-11"]["message"] = results["U-11"]["description"]["bad"]

# 검사 수행
check_rsyslog_conf_file()

# 결과를 JSON 파일로 저장
with open('result.json', 'w', encoding='utf-8') as f:
    json.dump(results, f, ensure_ascii=False, indent=4)

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
