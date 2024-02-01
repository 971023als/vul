#!/usr/bin/python3
import subprocess
import json

def check_unnecessary_gid():
    results = {
        "분류": "시스템 설정",
        "코드": "U-51",
        "위험도": "상",
        "진단 항목": "계정이 존재하지 않는 GID 금지",
        "진단 결과": "",
        "현황": [],
        "대응방안": "양호: 존재하지 않는 계정에 GID 설정을 금지한 경우\n취약: 존재하지 않은 계정에 GID 설정이 되어있는 경우"
    }

    necessary_groups = set([
        "root", "sudo", "sys", "adm", "wheel", "daemon", "bin", "lp", "dbus", "rpc",
        "rpcuser", "haldaemon", "apache", "postfix", "gdm", "adiosl", "mysql", "cubrid",
        "messagebus", "syslog", "avahi", "whoopsie", "colord", "systemd-network",
        "systemd-resolve", "systemd-timesync", "sync", "user", "tty", "disk", "men",
        "kmen", "mail", "uucp", "man", "games", "gopher", "video", "dip", "ftp", "lock",
        "audio", "nobody", "users", "usbmuxd", "utmp", "utempter", "rtkit", "avahi-autoipd",
        "desktop_admin_r", "desktop_user_r", "floppy", "vcsa", "abrt", "cdrom", "tape",
        "dialout", "wbpriv", "nfsnobody", "ntp", "saslauth", "postdrop", "pulse", 
        "pulse-access", "fuse", "sshd", "slocate", "stapusr", "stapsys", "tcpdump", "named",
        "www-data", "sasl", "nogroup", "ssh", "nfsnobody", "stapdev"
    ])

    try:
        all_groups = subprocess.check_output(["getent", "group"], text=True).strip().split("\n")
        group_names = {line.split(":")[0] for line in all_groups}

        unnecessary_groups = group_names - necessary_groups

        if unnecessary_groups:
            results["진단 결과"] = "취약"
            results["현황"].append(f"필요하지 않은 그룹이 발견되었습니다.: {', '.join(unnecessary_groups)}")
        else:
            results["진단 결과"] = "양호"
            results["현황"].append("불필요한 그룹을 찾을 수 없습니다.")
    except subprocess.CalledProcessError:
        results["현황"].append("그룹 정보를 가져올 수 없습니다.")
    except Exception as e:
        results["현황"].append(f"예외 발생: {str(e)}")

    return results

def main():
    results = check_unnecessary_gid()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()