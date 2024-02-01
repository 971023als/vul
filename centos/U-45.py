#!/usr/bin/python3
import os
import json
import grp
import subprocess

def check_su_restriction():
    results = {
        "분류": "계정 보안",
        "코드": "U-45",
        "위험도": "상",
        "진단 항목": "root 계정 su 제한",
        "진단 결과": "",
        "현황": [],
        "대응방안": "su 명령어를 특정 그룹에 속한 사용자만 사용하도록 제한"
    }

    # 휠 그룹 존재 여부 확인
    try:
        grp.getgrnam("wheel")
        wheel_exists = True
        results["현황"].append("휠 그룹이 존재합니다.")
    except KeyError:
        wheel_exists = False
        results["현황"].append("휠 그룹이 존재하지 않습니다.")

    # su 명령의 그룹 소유권과 권한 확인
    su_stat = os.stat("/bin/su")
    su_group = grp.getgrgid(su_stat.st_gid).gr_name
    su_permissions = oct(su_stat.st_mode)[-4:]

    if su_group != "wheel":
        results["현황"].append("su 명령은 휠 그룹이 소유하지 않습니다.")
    else:
        results["현황"].append("su 명령은 휠 그룹이 소유합니다.")

    if su_permissions != "4750":
        results["현황"].append("su 명령에 올바른 권한이 없습니다.")
    else:
        results["현황"].append("su 명령에 올바른 권한이 있습니다.")

    # 휠 그룹에 속한 사용자가 su 명령을 사용할 수 있는지 확인
    if wheel_exists:
        wheel_members = grp.getgrnam("wheel").gr_mem
        if wheel_members:
            results["현황"].append("휠 그룹의 계정이 su 명령을 사용할 수 있습니다.")
            results["진단 결과"] = "양호"
        else:
            results["현황"].append("휠 그룹의 어떤 계정도 su 명령을 사용할 수 없습니다.")
            results["진단 결과"] = "취약"
    else:
        results["진단 결과"] = "취약"

    return results

def main():
    results = check_su_restriction()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
