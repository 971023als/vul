#!/usr/bin/python3
import json

def check_user_shells():
    results = {
        "분류": "시스템 설정",
        "코드": "U-53",
        "위험도": "상",
        "진단 항목": "사용자 shell 점검",
        "진단 결과": "",
        "현황": [],
        "대응방안": "[양호]: 로그인이 필요하지 않은 계정에 /bin/false(nologin) 쉘이 부여되지 않은 경우\n[취약]: 로그인이 필요하지 않은 계정에 /bin/false(nologin) 쉘이 부여되어 있는 경우"
    }

    no_login_accounts = ["daemon", "bin", "sys", "adm", "listen", "nobody", "nobody4", "noaccess", "diag", "operator", "games", "gopher"]
    with open('/etc/passwd', 'r') as file:
        for line in file:
            user, _, _, _, _, _, shell = line.strip().split(":")
            if user in no_login_accounts:
                if shell in ["/bin/false", "/sbin/nologin"]:
                    results["현황"].append(f"OK: 사용자 {user} 셸이 {shell} 로 설정됨")
                else:
                    results["진단 결과"] = "취약"
                    results["현황"].append(f"WARN: 사용자 {user}의 셸이 /bin/false 또는 /sbin/nologin으로 설정되어 있지 않습니다. 현재 셸은 {shell} 입니다.")

    if "취약" not in results["진단 결과"]:
        results["진단 결과"] = "양호"

    return results

def main():
    results = check_user_shells()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()