#!/usr/bin/env python3
import json
import subprocess

# 결과를 저장할 딕셔너리
results = {
    "U-50": {
        "title": "관리자 그룹에 최소한의 계정 포함",
        "status": "",
        "description": {
            "good": "관리자 그룹에 불필요한 계정이 등록되어 있지 않은 경우",
            "bad": "관리자 그룹에 불필요한 계정이 등록되어 있는 경우"
        },
        "details": []
    }
}

# 필요한 계정 목록 정의
necessary_accounts = ["root", "bin", "daemon", "adm", "lp", "sync", "shutdown", "halt", "adiosl", "mysql", "cubrid"]

def check_admin_group_accounts():
    try:
        # 관리자 그룹의 계정 목록 가져오기
        proc = subprocess.Popen(['getent', 'group', 'root'], stdout=subprocess.PIPE)
        stdout, _ = proc.communicate()
        admin_accounts = stdout.decode().split(':')[-1].strip().split(',')
        
        # 불필요한 계정 검사
        unnecessary_accounts = [acc for acc in admin_accounts if acc not in necessary_accounts]

        if unnecessary_accounts:
            results["U-50"]["status"] = "취약"
            results["U-50"]["details"].extend(unnecessary_accounts)
        else:
            results["U-50"]["status"] = "양호"
            results["U-50"]["details"].append("관리자 그룹에 불필요한 계정이 없습니다.")
    except Exception as e:
        results["U-50"]["status"] = "에러"
        results["U-50"]["details"].append(f"관리자 그룹 계정 검사 중 오류 발생: {str(e)}")

check_admin_group_accounts()

# 결과 파일에 JSON 형태로 저장
result_file = 'admin_group_accounts_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
