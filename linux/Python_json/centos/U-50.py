#!/usr/bin/python3
import subprocess
import json

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

    exclusion_list = {"apache", "httpd", "mysql", "postgres"}  # Set for faster lookups

    try:
        output = subprocess.check_output(
            "getent group root | awk -F: '{split($4,a,\",\"); for(i in a) print a[i]}'", 
            shell=True, text=True
        )
        found_accounts = set(output.strip().split('\n')) - exclusion_list

        if found_accounts:
            results["진단 결과"] = "취약"
            results["현황"].append("관리자 그룹(root)에 불필요한 계정이 등록되어 있습니다: " + ", ".join(found_accounts))
        else:
            results["현황"].append("관리자 그룹(root)에는 불필요한 계정이 등록되지 않았습니다.")
    except subprocess.CalledProcessError as e:
        results["진단 결과"] = "오류"
        results["현황"].append("getent 명령어 실행 중 오류가 발생했습니다.")

    return results

def main():
    admin_group_accounts_check_results = check_admin_group_accounts()
    print(json.dumps(admin_group_accounts_check_results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
