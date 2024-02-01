#!/usr/bin/python3
import os
import stat
import pwd
import json

def check_rhosts_and_hosts_equiv():
    results = {
        "분류": "시스템 설정",
        "코드": "U-17",
        "위험도": "상",
        "진단 항목": "$HOME/.rhosts, hosts.equiv 사용 금지",
        "진단 결과": "",
        "현황": [],
        "대응방안": "[양호]: login, shell, exec 서비스를 사용하지 않거나 사용 시 아래와 같은 설정이 적용된 경우\n[취약]: login, shell, exec 서비스를 사용하고, 위와 같은 설정이 적용되지 않은 경우"
    }

    # Check /etc/hosts.equiv file
    hosts_equiv = "/etc/hosts.equiv"
    check_file_properties_and_content(hosts_equiv, "root", results)

    # Check $HOME/.rhosts files for all users
    for user_info in pwd.getpwall():
        if user_info.pw_shell not in ["/bin/false", "/sbin/nologin"]:  # Ignore system accounts
            rhosts = os.path.join(user_info.pw_dir, ".rhosts")
            check_file_properties_and_content(rhosts, user_info.pw_name, results)

    return results

def check_file_properties_and_content(file_path, expected_owner, results):
    if os.path.exists(file_path):
        owner = pwd.getpwuid(os.stat(file_path).st_uid).pw_name
        permissions = oct(os.stat(file_path).st_mode)[-3:]

        if owner != expected_owner:
            results["현황"].append(f"{file_path} 이(가) {expected_owner}에 의해 소유되지 않음({owner} 가 소유함)")

        if int(permissions) > 600:
            results["현황"].append(f"{file_path} 에 허용되지 않는 권한({permissions})이 있습니다.")

        with open(file_path, 'r') as file:
            if '+' in file.read():
                results["현황"].append(f"{file_path} '+' 설정이 있습니다")
    else:
        results["현황"].append(f"{file_path} 을(를) 찾을 수 없습니다")

def main():
    results = check_rhosts_and_hosts_equiv()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
