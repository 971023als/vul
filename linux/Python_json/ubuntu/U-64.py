#!/usr/bin/python3
import subprocess
import os
import json

def check_ftp_root_access_restriction():
    results = {
        "분류": "서비스 관리",
        "코드": "U-64",
        "위험도": "중",
        "진단 항목": "ftpusers 파일 설정(FTP 서비스 root 계정 접근제한)",
        "진단 결과": "양호",  # Assume "Good" until proven otherwise
        "현황": [],
        "대응방안": "FTP 서비스가 활성화된 경우 root 계정 접속을 차단"
    }

    ftpusers_files = [
        "/etc/ftpusers", "/etc/ftpd/ftpusers", "/etc/proftpd.conf",
        "/etc/vsftp/ftpusers", "/etc/vsftp/user_list", "/etc/vsftpd.ftpusers",
        "/etc/vsftpd.user_list"
    ]

    # Check for running FTP services
    ftp_running = subprocess.run(['ps', '-ef'], stdout=subprocess.PIPE, text=True).stdout
    if 'ftp' not in ftp_running and 'vsftpd' not in ftp_running and 'proftp' not in ftp_running:
        results["현황"].append("FTP 서비스가 비활성화 되어 있습니다.")
        return results  # No further checks needed if FTP services are not running

    # Check ftpusers files
    for ftpusers_file in ftpusers_files:
        if os.path.exists(ftpusers_file):
            if 'proftpd.conf' in ftpusers_file:
                with open(ftpusers_file, 'r') as file:
                    if any('RootLogin on' in line for line in file):
                        results["진단 결과"] = "취약"
                        results["현황"].append(f"{ftpusers_file} 파일에 'RootLogin on' 설정이 있습니다.")
                        return results
            else:
                with open(ftpusers_file, 'r') as file:
                    if 'root' not in file.read():
                        results["진단 결과"] = "취약"
                        results["현황"].append(f"{ftpusers_file} 파일에 'root' 계정이 없습니다.")
                        return results

    if not results["현황"]:
        results["현황"].append("ftp 서비스를 사용하고, 'root' 계정의 접근을 제한할 파일이 없습니다.")
        results["진단 결과"] = "취약"

    return results

def main():
    ftp_root_access_restriction_check_results = check_ftp_root_access_restriction()
    print(ftp_root_access_restriction_check_results)

if __name__ == "__main__":
    main()
