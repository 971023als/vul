#!/usr/bin/env python3
import json
import subprocess

# 결과를 저장할 딕셔너리
results = {
    "U-51": {
        "title": "계정이 존재하지 않는 GID 금지",
        "status": "",
        "description": {
            "good": "존재하지 않는 계정에 GID 설정을 금지한 경우",
            "bad": "존재하지 않은 계정에 GID 설정이 되어있는 경우"
        },
        "details": []
    }
}

# 필요한 그룹 목록
necessary_groups = [
    "root", "sudo", "sys", "adm", "wheel", "daemon", "bin", "lp", "dbus", 
    "rpc", "rpcuser", "haldaemon", "apache", "postfix", "gdm", "adiosl", 
    "mysql", "cubrid", "messagebus", "syslog", "avahi", "whoopsie", "colord", 
    "systemd-network", "systemd-resolve", "systemd-timesync", "sync", "user", 
    "tty", "disk", "mem", "kmem", "mail", "uucp", "man", "games", "gopher", 
    "video", "dip", "ftp", "lock", "audio", "nobody", "users", "usbmuxd", 
    "utmp", "utempter", "rtkit", "avahi-autoipd", "ssh", "nfsnobody", 
    "stapdev", "mem", "kmem", "www-data", "sasl", "nogroup", "ssh", "nfsnobody",
    "stapdev", "mem", "kmem"
]

def check_groups():
    # 시스템에 존재하는 모든 그룹 가져오기
    proc = subprocess.Popen(['getent', 'group'], stdout=subprocess.PIPE)
    stdout, _ = proc.communicate()
    all_groups = [line.split(':')[0] for line in stdout.decode().splitlines()]

    # 필요하지 않은 그룹 검사
    for group in all_groups:
        if group not in necessary_groups:
            results["U-51"]["details"].append(f"Group {group}은(는) 시스템 관리 또는 운영에 필요하지 않으므로 검토해야 합니다.")
            results["U-51"]["status"] = "취약"
        else:
            results["U-51"]["status"] = "양호"

check_groups()

# 결과 파일에 JSON 형태로 저장
result_file = 'gid_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
