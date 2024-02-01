#!/usr/bin/python3
import os
import pwd
import stat
import json

def check_hosts_equiv_and_rhosts_files():
    results = {
        "분류": "파일 및 디렉터리 관리",
        "코드": "U-17",
        "위험도": "상",
        "진단 항목": "$HOME/.rhosts, hosts.equiv 사용 금지",
        "진단 결과": "",
        "현황": [],
        "대응방안": "login, shell, exec 서비스 사용 시 /etc/hosts.equiv 및 $HOME/.rhosts 파일 소유자, 권한, 설정 검증"
    }

    # Check /etc/hosts.equiv
    hosts_equiv_path = '/etc/hosts.equiv'
    if os.path.exists(hosts_equiv_path):
        if check_file_security(hosts_equiv_path):
            results["현황"].append(f"{hosts_equiv_path} 파일 검증 완료.")
        else:
            results["현황"].append(f"{hosts_equiv_path} 파일 보안 조건 불충족.")

    # Check .rhosts in all user home directories
    for user in pwd.getpwall():
        home_dir = user.pw_dir
        rhosts_path = os.path.join(home_dir, '.rhosts')
        if os.path.isfile(rhosts_path):
            if check_file_security(rhosts_path, user.pw_uid):
                results["현황"].append(f"{rhosts_path} 파일 검증 완료.")
            else:
                results["현황"].append(f"{rhosts_path} 파일 보안 조건 불충족.")

    if not results["현황"]:
        results["진단 결과"] = "양호"
        results["현황"].append("보안 조건을 만족하는 /etc/hosts.equiv 및 $HOME/.rhosts 파일이 없거나 적절히 설정되었습니다.")
    else:
        results["진단 결과"] = "취약"

    return results

def check_file_security(file_path, owner_uid=None):
    file_stat = os.stat(file_path)
    mode = file_stat.st_mode
    # Check if owner is root or specified UID and permissions are 600 or less
    if (file_stat.st_uid == 0 or file_stat.st_uid == owner_uid) and (mode & 0o777) <= 0o600:
        # Check for '+' character in file content
        with open(file_path, 'r') as file:
            if '+' not in file.read():
                return True
    return False

def main():
    results = check_hosts_equiv_and_rhosts_files()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
