#!/usr/bin/python3
import os
import stat

def check_hosts_lpd_file():
    results = {
        "분류": "파일 및 디렉토리 관리",
        "코드": "U-55",
        "위험도": "하",
        "진단 항목": "hosts.lpd 파일 소유자 및 권한 설정",
        "진단 결과": "양호",  # Assume "Good" until proven otherwise
        "현황": [],
        "대응방안": "hosts.lpd 파일이 없거나, root 소유 및 권한 600 설정"
    }

    hosts_lpd_path = "/etc/hosts.lpd"
    if os.path.isfile(hosts_lpd_path):
        file_stat = os.stat(hosts_lpd_path)
        file_mode = stat.S_IMODE(file_stat.st_mode)
        file_owner = file_stat.st_uid

        # Check if owner is root (UID 0)
        if file_owner == 0:
            # Check if permissions are set to 600
            if file_mode == 0o600:
                # File exists, owned by root, and permissions are correct
                pass
            else:
                results["진단 결과"] = "취약"
                results["현황"].append(f"{hosts_lpd_path} 파일의 권한이 600이 아닙니다.")
        else:
            results["진단 결과"] = "취약"
            results["현황"].append(f"{hosts_lpd_path} 파일의 소유자(owner)가 root가 아닙니다.")
    else:
        # File does not exist, considered Good
        pass

    return results

def main():
    hosts_lpd_file_check_results = check_hosts_lpd_file()
    print(hosts_lpd_file_check_results)

if __name__ == "__main__":
    main()
