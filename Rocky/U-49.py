#!/usr/bin/python3
import re
import json

def check_unnecessary_accounts():
    results = {
        "분류": "시스템 설정",
        "코드": "U-49",
        "위험도": "상",
        "진단 항목": "불필요한 계정 제거",
        "진단 결과": "",
        "현황": [],
        "대응방안": "[양호]: 불필요한 계정이 존재하지 않는 경우\n[취약]: 불필요한 계정이 존재하는 경우"
    }

    default_accounts = set([
        "root", "bin", "daemon", "adm", "lp", "sync", "shutdown", "halt", "ubuntu",
        "messagebus", "syslog", "avahi", "kernoops", "whoopsie", "colord",
        "systemd-network", "systemd-resolve", "systemd-timesync", "dbus", "rpc",
        "rpcuser", "haldaemon", "apache", "postfix", "gdm", "sys", "games", "man",
        "news", "uucp", "proxy", "www-data", "backup", "list", "irc", "gnats", "nobody",
        "_apt", "tss", "uuidd", "tcpdump", "avahi-autoipd", "usbmux", "rtkit", "dnsmasq",
        "cups-pk-helper", "speech-dispatcher", "saned", "nm-openvpn", "hplip", "geoclue",
        "pulse", "gnome-initial-setup", "systemd-coredump", "fwupd-refresh", "adios", "mysql",
        "curvid", "user"
    ])
    
    suspected_accounts = []

    with open('/etc/passwd', 'r') as file:
        for line in file:
            if 'bash' in line:
                user = line.split(':')[0]
                if user not in default_accounts:
                    suspected_accounts.append(user)

    if suspected_accounts:
        results["진단 결과"] = "취약"
        results["현황"].append(f"용도가 의심되는 계정 발견: {', '.join(suspected_accounts)}")
    else:
        results["진단 결과"] = "양호"
        results["현황"].append("용도가 의심되는 계정이 없습니다")

    return results

def main():
    results = check_unnecessary_accounts()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()