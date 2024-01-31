#!/bin/python3

import subprocess
import json

# 기본 계정 목록
default_accounts = [
    "root", "bin", "daemon", "adm", "lp", "sync", "shutdown", "halt",
    "ubuntu", "messagebus", "syslog", "avahi", "kernoops", "whoopsie",
    "colord", "systemd-network", "systemd-resolve", "systemd-timesync",
    "dbus", "rpc", "rpcuser", "haldaemon", "apache", "postfix", "gdm",
    "sys", "games", "man", "news", "uucp", "proxy", "www-data", "backup",
    "list", "irc", "gnats", "nobody", "_apt", "tss", "uuidd", "tcpdump",
    "avahi-autoipd", "usbmux", "rtkit", "dnsmasq", "cups-pk-helper",
    "speech-dispatcher", "saned", "nm-openvpn", "hplip", "geoclue",
    "pulse", "gnome-initial-setup", "systemd-coredump", "fwupd-refresh",
    "adiosl", "mysql", "cubrid", "user"
]

# /etc/passwd 파일에서 사용자 목록을 가져옵니다
user_list = subprocess.check_output("awk -F: '$7 ~ /bash$/ {print $1}' /etc/passwd", shell=True, text=True).splitlines()

# 불필요한 계정 식별
unnecessary_accounts = [user for user in user_list if user not in default_accounts]

# 결과 저장을 위한 딕셔너리
results = {
    "분류": "서비스 관리",
    "코드": "U-49",
    "위험도": "상",
    "진단 항목": "불필요한 계정 제거",
    "진단 결과": "취약" if unnecessary_accounts else "양호",
    "현황": f"용도가 의심되는 계정 발견: {', '.join(unnecessary_accounts)}" if unnecessary_accounts else "용도가 의심되는 계정이 없습니다.",
    "대응방안": "불필요한 계정을 제거하십시오." if unnecessary_accounts else "현재 설정 유지"
}

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
