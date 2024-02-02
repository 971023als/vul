#!/usr/bin/python3
import os

def check_unnecessary_accounts():
    results = {
        "분류": "계정관리",
        "코드": "U-49",
        "위험도": "하",
        "진단 항목": "불필요한 계정 제거",
        "진단 결과": "양호",  # Assume "Good" until proven otherwise
        "현황": [],
        "대응방안": "불필요한 계정이 존재하지 않도록 관리"
    }

    unnecessary_accounts = [
        "root", "bin", "daemon", "adm", "lp", "sync", "shutdown", "halt", "ubuntu",
        "messagebus", "syslog", "avahi", "kernoops", "whoopsie", "colord",
        "systemd-network", "systemd-resolve", "systemd-timesync", "dbus", "rpc",
        "rpcuser", "haldaemon", "apache", "postfix", "gdm", "sys", "games", "man",
        "news", "uucp", "proxy", "www-data", "backup", "list", "irc", "gnats", "nobody",
        "_apt", "tss", "uuidd", "tcpdump", "avahi-autoipd", "usbmux", "rtkit", "dnsmasq",
        "cups-pk-helper", "speech-dispatcher", "saned", "nm-openvpn", "hplip", "geoclue",
        "pulse", "gnome-initial-setup", "systemd-coredump", "fwupd-refresh", "adios", "mysql",
        "curvid", "user"
    ]

    if os.path.isfile("/etc/passwd"):
        with open("/etc/passwd", 'r') as file:
            passwd_contents = file.readlines()
            found_accounts = []
            for account in passwd_contents:
                account_name = account.split(":")[0]
                if account_name in unnecessary_accounts:
                    found_accounts.append(account_name)

            if found_accounts:
                results["진단 결과"] = "취약"
                results["현황"].append("불필요한 계정이 존재합니다: " + ", ".join(found_accounts))
            else:
                # If no unnecessary accounts are found, it's considered Good and we don't need to update anything.
                pass
    else:
        results["진단 결과"] = "취약"
        results["현황"].append("/etc/passwd 파일이 없습니다.")

    return results

def main():
    unnecessary_accounts_check_results = check_unnecessary_accounts()
    print(unnecessary_accounts_check_results)

if __name__ == "__main__":
    main()
