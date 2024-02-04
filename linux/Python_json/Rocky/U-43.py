#!/usr/bin/python3
import subprocess
import os
import json

def check_log_review_and_reporting():
    results = {
        "분류": "로그 관리",
        "코드": "U-43",
        "위험도": "상",
        "진단 항목": "로그의 정기적 검토 및 보고",
        "진단 결과": None,  # 초기 상태 설정, 검사 후 결과에 따라 업데이트
        "현황": [],
        "대응방안": "보안 로그, 응용 프로그램 및 시스템 로그 기록의 정기적 검토, 분석, 리포트 작성 및 보고 조치 실행"
    }

    # 로그 파일 상태 확인
    log_files_results = check_log_files()
    results["현황"].extend(log_files_results)

    # Sudo 로그 상태 확인
    sudo_logs_results = check_sudo_logs()
    results["현황"].extend(sudo_logs_results)

    # FTP 로그 상태 확인
    ftp_logs_results = check_ftp_logs()
    results["현황"].extend(ftp_logs_results)

    # 진단 결과 설정
    if any(result["결과"] == "취약" for result in results["현황"]):
        results["진단 결과"] = "취약"
    else:
        results["진단 결과"] = "양호"

    return results

def check_log_file_existence(file_path):
    try:
        with open(file_path, 'r'):
            return True
    except FileNotFoundError:
        return False

def check_log_files():
    LOG_DIR = "/var/log"
    UTMP = f"{LOG_DIR}/utmp"
    WTMP = f"{LOG_DIR}/wtmp"
    BTMP = f"{LOG_DIR}/btmp"
    
    results = []

    if check_log_file_existence(UTMP):
        results.append({"파일명": "UTMP", "결과": "존재함"})
    else:
        results.append({"파일명": "UTMP", "결과": "존재하지 않음"})

    if check_log_file_existence(WTMP):
        results.append({"파일명": "WTMP", "결과": "존재함"})
    else:
        results.append({"파일명": "WTMP", "결과": "존재하지 않음"})

    if check_log_file_existence(BTMP):
        results.append({"파일명": "BTMP", "결과": "존재함"})
    else:
        results.append({"파일명": "BTMP", "결과": "존재하지 않음"})

    return results

def check_sudo_logs():
    SULOG_FILE = "/var/log/sulog"
    ALLOWED_ACCOUNTS = [
        "root",
        "bin",
        "daemon",
        "adm",
        "lp",
        "sync",
        "shutdown",
        "halt",
        "ubuntu",
        "user",
        "messagebus",
        "syslog",
        "avahi",
        "kernoops",
        "whoopsie",
        "colord",
        "systemd-network",
        "systemd-resolve",
        "systemd-timesync",
        "mysql",
        "dbus",
        "rpc",
        "rpcuser",
        "haldaemon",
        "apache",
        "postfix",
        "gdm",
        "adiosl",
        "cubrid"
    ]

    results = []

    try:
        with open(SULOG_FILE, 'r') as sulog:
            for line in sulog:
                parts = line.split()
                if len(parts) >= 4:
                    username = parts[0]
                    granted = parts[2]
                    granted_to = parts[3]

                    if granted != "to":
                        continue

                    if granted_to in ALLOWED_ACCOUNTS:
                        results.append({"파일명": "SULOG", "사용자": username, "권한": granted_to, "결과": "허용됨"})
                    else:
                        results.append({"파일명": "SULOG", "사용자": username, "권한": granted_to, "결과": "허용되지 않음"})

    except FileNotFoundError:
        results.append({"파일명": "SULOG", "결과": "파일이 존재하지 않음"})

    return results

def check_ftp_logs():
    XFERLOG = "/var/log/xferlog"
    FTPUSERS_FILE = "/etc/ftpusers"
    ALLOWED_ACCOUNTS = [
        "root",
        "bin",
        "daemon",
        "adm",
        "lp",
        "sync",
        "shutdown",
        "halt",
        "ubuntu",
        "user",
        "messagebus",
        "syslog",
        "avahi",
        "kernoops",
        "whoopsie",
        "colord",
        "systemd-network",
        "systemd-resolve",
        "systemd-timesync",
        "mysql",
        "dbus",
        "rpc",
        "rpcuser",
        "haldaemon",
        "apache",
        "postfix",
        "gdm",
        "adiosl",
        "cubrid"
    ]

    results = []

    try:
        with open(XFERLOG, 'r') as xferlog:
            for line in xferlog:
                parts = line.split()
                if len(parts) >= 3:
                    ip = parts[0]
                    user = parts[1]
                    date = parts[2]

                    if not any(user in line for user in ALLOWED_ACCOUNTS):
                        results.append({"파일명": "XFERLOG", "IP 주소": ip, "사용자": user, "액세스 날짜": date, "결과": "인증되지 않음"})

    except FileNotFoundError:
        results.append({"파일명": "XFERLOG", "결과": "파일이 존재하지 않음"})

    return results

def main():
    results = check_log_review_and_reporting()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
