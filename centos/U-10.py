#!/usr/bin/python3
import os
import stat
import json

def check_xinetd_conf_file_ownership_and_permissions():
    results = {
        "분류": "시스템 설정",
        "코드": "U-10",
        "위험도": "상",
        "진단 항목": "/etc/xinetd.conf 파일 소유자 및 권한 설정",
        "진단 결과": "",
        "현황": [],
        "대응방안": "[양호]: /etc/xinetd.conf 파일의 소유자가 root이고, 권한이 600인 경우\n[취약]: /etc/xinetd.conf 파일의 소유자가 root가 아니거나, 권한이 600이 아닌 경우"
    }

    xinetd_conf_file = "/etc/xinetd.conf"
    if not os.path.exists(xinetd_conf_file):
        results["진단 결과"] = "정보 부족"
        results["현황"].append(f"{xinetd_conf_file} 파일이 없습니다.")
    else:
        file_stat = os.stat(xinetd_conf_file)
        file_owner = stat.filemode(file_stat.st_mode)
        file_permissions = oct(file_stat.st_mode)[-3:]

        if os.getuid() == file_stat.st_uid:
            results["진단 결과"] = "양호"
            results["현황"].append(f"{xinetd_conf_file}가 루트에 의해 소유됩니다.")
        else:
            results["진단 결과"] = "취약"
            results["현황"].append(f"{xinetd_conf_file}가 루트에 의해 소유되지 않음")

        if int(file_permissions) == 600:
            results["진단 결과"] = "양호"
            results["현황"].append(f"{xinetd_conf_file}에 권한은 600 이하 입니다.")
        else:
            results["진단 결과"] = "취약"
            results["현황"].append(f"{xinetd_conf_file}에 권한이 600 초과입니다")

    return results

def main():
    results = check_xinetd_conf_file_ownership_and_permissions()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
