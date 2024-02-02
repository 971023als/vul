#!/usr/bin/python3
import os
import pwd
import stat
import json
import glob

def is_permission_secure(path, owner_expected):
    """파일의 권한과 소유자를 확인하고 '+' 문자의 존재 여부도 검사합니다."""
    stat_info = os.stat(path)
    mode = stat_info.st_mode
    owner = pwd.getpwuid(stat_info.st_uid).pw_name

    # 소유자 확인
    if owner != owner_expected:
        return False, f'{path}: 소유자가 {owner_expected}가 아님'

    # 권한 확인 (600 이하인지)
    if mode & 0o777 > 0o600:
        return False, f'{path}: 권한이 600보다 큼'

    # 그룹 또는 다른 사용자(other)의 권한이 없는지 확인
    if mode & 0o077:
        return False, f'{path}: 그룹 또는 다른 사용자에게 권한이 있음'

    # '+' 문자의 존재 확인
    with open(path, 'r') as file:
        if '+' in file.read():
            return False, f'{path}: 파일 내에 "+" 문자가 있음'

    return True, ''

def check_hosts_and_rhosts_files():
    results = {
        "분류": "파일 및 디렉터리 관리",
        "코드": "U-17",
        "위험도": "상",
        "진단 항목": "$HOME/.rhosts, hosts.equiv 사용 금지",
        "진단 결과": "양호",
        "현황": [],
        "대응방안": "login, shell, exec 서비스 사용 시 /etc/hosts.equiv 및 $HOME/.rhosts 파일 소유자, 권한, 설정 검증"
    }

    # /etc/hosts.equiv 파일 검증
    hosts_equiv_path = '/etc/hosts.equiv'
    if os.path.exists(hosts_equiv_path):
        secure, message = is_permission_secure(hosts_equiv_path, 'root')
        if not secure:
            results['현황'].append(message)
            results["진단 결과"] = "취약"

    # 사용자별 .rhosts 파일 검증
    for user_info in pwd.getpwall():
        home_dir = user_info.pw_dir
        rhosts_path = os.path.join(home_dir, '.rhosts')
        if os.path.exists(rhosts_path):
            secure, message = is_permission_secure(rhosts_path, user_info.pw_name)
            if not secure:
                results['현황'].append(message)
                results["진단 결과"] = "취약"

    if not results['현황']:
        results["현황"].append("login, shell, exec 서비스 사용 시 /etc/hosts.equiv 및 $HOME/.rhosts 파일 문제 없음")
        results["진단 결과"] = "양호"
    return results

def main():
    results = check_hosts_and_rhosts_files()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
