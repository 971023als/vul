#!/usr/bin/python3

import os
import subprocess
import json

def check_rhosts_hosts_equiv_usage():
    results = {
        "분류": "서비스 관리",
        "코드": "U-17",
        "위험도": "상",
        "진단 항목": "$HOME/.rhosts, hosts.equiv 사용 금지",
        "진단 결과": "",
        "현황": [],
        "대응방안": "login, shell, exec 서비스 사용 시 안전한 설정 적용 권장."
    }

    equiv_file = "/etc/hosts.equiv"
    rhosts_file = os.path.join(os.path.expanduser('~'), ".rhosts")

    # Check /etc/hosts.equiv file
    if os.path.exists(equiv_file):
        equiv_perms = oct(os.stat(equiv_file).st_mode)[-3:]
        if equiv_perms <= "600":
            results["현황"].append(f"{equiv_file} 권한이 안전합니다.")
        else:
            results["현황"].append(f"{equiv_file} 권한이 600 이하가 아닙니다.")

        with open(equiv_file, 'r') as file:
            if '+' in file.read():
                results["현황"].append(f"{equiv_file} 파일에 '+' 설정이 있습니다.")
    else:
        results["현황"].append(f"{equiv_file} 파일이 존재하지 않습니다.")

    # Check $HOME/.rhosts file
    if os.path.exists(rhosts_file):
        rhosts_perms = oct(os.stat(rhosts_file).st_mode)[-3:]
        if rhosts_perms <= "600":
            results["현황"].append(f"{rhosts_file} 권한이 안전합니다.")
        else:
            results["현황"].append(f"{rhosts_file} 권한이 600 이하가 아닙니다.")

        with open(rhosts_file, 'r') as file:
            if '+' in file.read():
                results["현황"].append(f"{rhosts_file} 파일에 '+' 설정이 있습니다.")
    else:
        results["현황"].append(f"{rhosts_file} 파일이 존재하지 않습니다.")

    # Determine overall result
    if "600 이하가 아닙니다." in results["현황"] or "'+' 설정이 있습니다." in results["현황"]:
        results["진단 결과"] = "취약"
    else:
        results["진단 결과"] = "양호"

    return results

def main():
    results = check_rhosts_hosts_equiv_usage()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
