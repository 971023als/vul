import pwd
import json

# 결과를 저장할 딕셔너리
results = {
    "U-49": {
        "title": "불필요한 계정 제거",
        "status": "",
        "description": {
            "good": "불필요한 계정이 존재하지 않는 경우",
            "bad": "불필요한 계정이 존재하는 경우",
        },
        "suspected_accounts": []
    }
}

# 기본 계정 목록 지정
default_accounts = set([
    "root", "bin", "daemon", "adm", "lp", "sync", "shutdown", "halt", "ubuntu",
    "messagebus", "syslog", "avahi", "kernoops", "whoopsie", "colord", "systemd-network",
    "systemd-resolve", "systemd-timesync", "dbus", "rpc", "rpcuser", "haldaemon",
    "apache", "postfix", "gdm", "sys", "games", "man", "news", "uucp", "proxy", "www-data",
    "backup", "list", "irc", "gnarts", "nobody", "_apt", "tss", "uuidd", "tcpdump",
    "avahi-autoipad", "usbmux", "rtkit", "dnsmasq", "cups-pk-helper", "speech-dispatcher",
    "saned", "nm-openvpn", "hplip", "geoclue", "pulse", "gnome-initial-setup",
    "systemd-coredump", "fwupd-refresh", "adiosl", "mysql", "cubrid", "user"
])

# 시스템의 모든 사용자 계정을 검사
for user_info in pwd.getpwall():
    user_name = user_info.pw_name
    # 사용자가 기본 계정 목록에 없는 경우, 의심 목록에 추가
    if user_name not in default_accounts:
        results["suspected_accounts"].append(user_name)

# 결과 상태 설정
if results["suspected_accounts"]:
    results["status"] = "취약"
    results["description"]["bad"] += " 다음 용도가 의심되는 계정이 발견되었습니다: " + ", ".join(results["suspected_accounts"])
else:
    results["status"] = "양호"
    results["description"]["good"] += " 시스템에 불필요한 계정이 존재하지 않습니다."

# 결과를 JSON 파일로 저장
with open('result.json', 'w', encoding='utf-8') as f:
    json.dump(results, f, ensure_ascii=False, indent=4)

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
