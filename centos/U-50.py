#!/usr/bin/python3
import os

def check_admin_group_accounts():
    results = {
        "분류": "계정관리",
        "코드": "U-50",
        "위험도": "하",
        "진단 항목": "관리자 그룹에 최소한의 계정 포함",
        "진단 결과": "양호",  # Assume "Good" until proven otherwise
        "현황": [],
        "대응방안": "관리자 그룹(root)에 불필요한 계정이 등록되지 않도록 관리"
    }

    unnecessary_accounts = [
        "daemon", "bin", "sys", "adm", "listen", "nobody", "nobody4",
        "noaccess", "diag", "operator", "gopher", "games", "ftp", "apache",
        "httpd", "www-data", "mysql", "mariadb", "postgres", "mail", "postfix",
        "news", "lp", "uucp", "nuucp" "root", "daemon", "adm", "lp", "sync", "shutdown", "halt", "ubuntu", "user"
    ]

    if os.path.isfile("/etc/group"):
        with open("/etc/group", 'r') as file:
            groups_contents = file.readlines()
            for group_line in groups_contents:
                group_info = group_line.split(":")
                if group_info[0] == "root":
                    root_members = group_info[3].strip().split(',')
                    found_accounts = [acc for acc in root_members if acc in unnecessary_accounts]
                    if found_accounts:
                        results["진단 결과"] = "취약"
                        results["현황"].append("관리자 그룹(root)에 불필요한 계정이 등록되어 있습니다: " + ", ".join(found_accounts))
                    break
            else:
                # If the root group is not found or contains no unnecessary accounts, it's considered Good.
                pass
    else:
        results["진단 결과"] = "취약"
        results["현황"].append("/etc/group 파일이 없습니다.")

    return results

def main():
    admin_group_accounts_check_results = check_admin_group_accounts()
    print(admin_group_accounts_check_results)

if __name__ == "__main__":
    main()
