#!/usr/bin/env python3
import json
import subprocess

# 결과를 저장할 딕셔너리
results = {
    "U-49": {
        "title": "불필요한 계정 제거",
        "status": "",
        "description": {
            "good": "불필요한 계정이 존재하지 않는 경우",
            "bad": "불필요한 계정이 존재하는 경우"
        },
        "details": []
    }
}

# 기본 계정 목록
default_accounts = [
    "root", "bin", "daemon", "adm", "lp", "sync", "shutdown", "halt", "ubuntu",
    "messagebus", "syslog", "avahi", "kernoops", "whoopsie", "colord",
    "systemd-network", "systemd-resolve", "systemd-timesync", "dbus", "rpc",
    "rpcuser", "haldaemon", "apache", "postfix", "gdm", "sys", "games", "man",
    "news", "uucp", "proxy", "www-data", "backup", "list", "irc", "gnats",
    "nobody", "_apt", "tss", "uuidd", "tcpdump", "avahi-autoipd", "usbmux",
    "rtkit", "dnsmasq", "cups-pk-helper", "speech-dispatcher", "saned",
    "nm-openvpn", "hplip", "geoclue", "pulse", "gnome-initial-setup",
    "systemd-coredump", "fwupd-refresh", "adiosl", "mysql", "cubrid", "user"
]

def check_unnecessary_accounts():
    # /etc/passwd에서 사용자 목록 가져오기
    proc = subprocess.Popen(['getent', 'passwd'], stdout=subprocess.PIPE)
    stdout, _ = proc.communicate()
    user_list = stdout.decode().splitlines()

    suspicious_accounts = []
    for user_line in user_list:
        user_name = user_line.split(':')[0]
        if user_name not in default_accounts:
            suspicious_accounts.append(user_name)

    if suspicious_accounts:
        results["U-49"]["status"] = "취약"
        results["U-49"]["details"].extend(suspicious_accounts)
    else:
        results["U-49"]["status"] = "양호"
        results["U-49"]["details"].append("불필요한 계정이 존재하지 않습니다.")

check_unnecessary_accounts()

# 결과 파일에 JSON 형태로 저장
result_file = 'unnecessary_accounts_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
