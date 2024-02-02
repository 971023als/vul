#!/usr/bin/python3
import os
import stat

def check_ftpusers_file_permissions():
    results = {
        "분류": "서비스 관리",
        "코드": "U-63",
        "위험도": "하",
        "진단 항목": "ftpusers 파일 소유자 및 권한 설정",
        "진단 결과": "양호",  # Assume "Good" until proven otherwise
        "현황": [],
        "대응방안": "ftpusers 파일의 소유자를 root로 설정하고, 권한을 640 이하로 설정"
    }

    ftpusers_files = [
        "/etc/ftpusers", "/etc/pure-ftpd/ftpusers", "/etc/wu-ftpd/ftpusers",
        "/etc/vsftpd/ftpusers", "/etc/proftpd/ftpusers", "/etc/ftpd/ftpusers",
        "/etc/vsftpd.ftpusers", "/etc/vsftpd.user_list", "/etc/vsftpd/user_list"
    ]

    file_exists_count = 0

    for ftpusers_file in ftpusers_files:
        if os.path.isfile(ftpusers_file):
            file_exists_count += 1
            st = os.stat(ftpusers_file)
            mode = st.st_mode
            owner = st.st_uid
            permissions = stat.S_IMODE(mode)

            # Check if owner is root
            if owner == 0:
                # Check if permissions are 640 or less
                if permissions <= 0o640:
                    continue
                else:
                    results["진단 결과"] = "취약"
                    results["현황"].append(f"{ftpusers_file} 파일의 권한이 640보다 큽니다.")
            else:
                results["진단 결과"] = "취약"
                results["현황"].append(f"{ftpusers_file} 파일의 소유자(owner)가 root가 아닙니다.")

    if file_exists_count == 0:
        results["진단 결과"] = "취약"
        results["현황"].append("ftp 접근제어 파일이 없습니다.")

    return results

def main():
    ftpusers_file_check_results = check_ftpusers_file_permissions()
    print(ftpusers_file_check_results)

if __name__ == "__main__":
    main()
