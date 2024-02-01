#!/usr/bin/python3
import subprocess
import json

def check_admin_group_accounts():
    results = {
        "분류": "시스템 설정",
        "코드": "U-50",
        "위험도": "상",
        "진단 항목": "관리자 그룹에 최소한의 계정 포함",
        "진단 결과": "",
        "현황": [],
        "대응방안": "양호: 관리자 그룹에 불필요한 계정이 등록되어 있지 않은 경우\n취약: 관리자 그룹에 불필요한 계정이 등록되어 있는 경우"
    }

    necessary_accounts = {"root", "bin", "daemon", "adm", "lp", "sync", "shutdown", "halt", "ubuntu", "user"}
    admin_group = "sudo"  # 대부분의 시스템에서 관리자 그룹은 'sudo'입니다. 필요에 따라 변경하세요.

    try:
        group_info = subprocess.check_output(["getent", "group", admin_group], text=True).strip()
        members = set(group_info.split(":")[-1].split(","))
        unnecessary_accounts = members - necessary_accounts

        if unnecessary_accounts:
            results["진단 결과"] = "취약"
            results["현황"].append(f"관리자 그룹에서 불필요한 계정이 발견되었습니다.: {', '.join(unnecessary_accounts)}")
        else:
            results["진단 결과"] = "양호"
            results["현황"].append("관리자 그룹에서 불필요한 계정을 찾을 수 없습니다.")
    except subprocess.CalledProcessError:
        results["현황"].append(f"{admin_group} 그룹 정보를 가져올 수 없습니다.")
    except Exception as e:
        results["현황"].append(f"예외 발생: {str(e)}")

    return results

def main():
    results = check_admin_group_accounts()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()