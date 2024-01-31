#!/bin/python3

import subprocess
import json

# 필요한 그룹 목록 정의
necessary_groups = [
    "root", "sudo", "sys", "adm", "wheel", "daemon", "bin", "lp", "dbus", 
    "rpc", "rpcuser", "haldaemon", "apache", "postfix", "gdm", "adiosl", 
    "mysql", "cubrid", "messagebus", "syslog", "avahi", "whoopsie", "colord", 
    "systemd-network", "systemd-resolve", "systemd-timesync", "mysql", "sync", 
    "user", "tty", "disk", "mem", "kmem", "mail", "uucp", "man", "games", 
    "gopher", "video", "dip", "ftp", "lock", "audio", "nobody", "users", 
    "usbmuxd", "utmp", "utempter", "rtkit", "avahi-autoipd", "desktop_admin_r", 
    "desktop_user_r", "floppy", "vcsa", "abrt", "cdrom", "tape", "dialout", 
    "wbpriv", "nfsnobody", "ntp", "saslauth", "postdrop", "pulse", "pulse-access", 
    "fuse", "sshd", "slocate", "stapusr", "stapsys", "tcpdump", "named", 
    "www-data", "sasl", "nogroup", "ssh", "nfsnobody", "stapdev", "kmem"
]

# 모든 그룹 목록을 가져옵니다
all_groups_output = subprocess.check_output("getent group", shell=True, text=True)
all_groups = [line.split(':')[0] for line in all_groups_output.strip().split('\n')]

# 결과 저장을 위한 리스트
results = []

# 필요한 그룹 목록에 없는 그룹 식별
for group in all_groups:
    if group not in necessary_groups:
        results.append(f"WARNING: Group {group}은(는) 시스템 관리 또는 운영에 필요하지 않으므로 검토해야 합니다.")
    else:
        results.append(f"OK: Group {group}은(는) 시스템 관리 또는 운영에 필요합니다.")

# 결과 요약
summary = {
    "분류": "서비스 관리",
    "코드": "U-51",
    "위험도": "상",
    "진단 항목": "계정이 존재하지 않는 GID 금지",
    "진단 결과": "WARNING" if len(results) > len(necessary_groups) else "OK",
    "현황": f"{len(all_groups) - len(necessary_groups)}개의 검토가 필요한 그룹이 발견되었습니다." if len(results) > len(necessary_groups) else "불필요한 계정이 존재하지 않습니다.",
    "대응방안": "불필요한 그룹을 제거하거나 정당화합니다."
}

# 결과 출력
print(json.dumps(summary, ensure_ascii=False, indent=4))
for result in results:
    print(result)
