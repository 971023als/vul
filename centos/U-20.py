#!/usr/bin/python3
import os
import re
import json

def check_anonymous_ftp_disabled():
    results = {
        "분류": "서비스 관리",
        "코드": "U-20",
        "위험도": "상",
        "진단 항목": "Anonymous FTP 비활성화",
        "진단 결과": "양호",  # Assume "Good" until proven otherwise
        "현황": [],
        "대응방안": "Anonymous FTP (익명 ftp) 접속을 차단한 경우"
    }

    proftpd_conf_files = find_files('/etc', 'proftpd.conf')
    vsftpd_conf_files = find_files('/etc', 'vsftpd.conf')

    for conf_file in proftpd_conf_files + vsftpd_conf_files:
        if 'proftpd' in conf_file:
            if check_proftpd_conf(conf_file):
                results["진단 결과"] = "취약"
                results["현황"].append(f"{conf_file} 파일에서 Anonymous FTP 접속이 허용될 수 있습니다.")
        elif 'vsftpd' in conf_file:
            if check_vsftpd_conf(conf_file):
                results["진단 결과"] = "취약"
                results["현황"].append(f"{conf_file} 파일에서 Anonymous FTP 접속이 허용될 수 있습니다.")

    if results["진단 결과"] == "양호":
        results["현황"].append("Anonymous FTP 접속이 차단되어 있습니다.")

    return results

def find_files(directory, file_name):
    found_files = []
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file == file_name:
                found_files.append(os.path.join(root, file))
    return found_files

def check_proftpd_conf(file_path):
    with open(file_path, 'r') as file:
        contents = file.read()
        return '<Anonymous' in contents and '</Anonymous>' in contents

def check_vsftpd_conf(file_path):
    with open(file_path, 'r') as file:
        for line in file:
            if re.match(r'^anonymous_enable=YES', line, re.IGNORECASE):
                return True
    return False

def main():
    results = check_anonymous_ftp_disabled()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
