#!/usr/bin/python3
import os
import stat
import pwd
import json

def check_ftpusers_file_permissions():
    results = {
        "분류": "시스템 설정",
        "코드": "U-63",
        "위험도": "상",
        "진단 항목": "ftpusers 파일 소유자 및 권한 설정",
        "진단 결과": "",
        "현황": [],
        "대응방안": "[양호]: ftpusers 파일의 소유자가 root이고, 권한이 640 이하인 경우\n[취약]: ftpusers 파일의 소유자가 root아니거나, 권한이 640 이하가 아닌 경우"
    }

    ftpusers_file = "/etc/vsftpd/ftpusers"
    if not os.path.exists(ftpusers_file):
        results["현황"].append("ftpusers 파일이 없습니다. 확인해주세요.")
    else:
        file_stat = os.stat(ftpusers_file)
        file_owner = pwd.getpwuid(file_stat.st_uid).pw_name
        file_perms = stat.S_IMODE(file_stat.st_mode)

        if file_owner != "root":
            results["진단 결과"] = "취약"
            results["현황"].append("root가 ftpusers 파일을 소유하고 있지 않습니다.")
        elif file_perms > 0o640:
            results["진단 결과"] = "취약"
            results["현황"].append(f"권한이 640 초과입니다: 현재 권한 {oct(file_perms)}")
        else:
            results["진단 결과"] = "양호"
            results["현황"].append("ftpusers 파일의 소유자가 root이고, 권한이 640 이하입니다.")

    return results

def main():
    results = check_ftpusers_file_permissions()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()