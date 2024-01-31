#!/bin/python3

import subprocess
import json

# 필요한 계정 목록 정의
necessary_accounts = set(["root", "bin", "daemon", "adm", "lp", "sync", "shutdown", "halt", "adiosl", "mysql", "cubrid"])

# 관리자 그룹의 계정 목록을 가져옵니다
try:
    admin_group_accounts = subprocess.check_output("getent group root", shell=True, text=True).strip().split(":")[-1].split(",")
except subprocess.CalledProcessError:
    admin_group_accounts = []

# 필요한 계정 목록에 없는 계정을 식별합니다
unnecessary_accounts = [account for account in admin_group_accounts if account not in necessary_accounts]

# 결과 저장을 위한 딕셔너리
results = {
    "분류": "서비스 관리",
    "코드": "U-50",
    "위험도": "상",
    "진단 항목": "관리자 그룹에 최소한의 계정 포함",
    "진단 결과": "취약" if unnecessary_accounts else "양호",
    "현황": f"관리자 그룹에 불필요한 계정이 등록되어 있습니다: {', '.join(unnecessary_accounts)}" if unnecessary_accounts else "관리자 그룹에 불필요한 계정이 등록되어 있지 않습니다.",
    "대응방안": "관리자 그룹에서 불필요한 계정을 제거하십시오." if unnecessary_accounts else "현재 설정 유지"
}

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
