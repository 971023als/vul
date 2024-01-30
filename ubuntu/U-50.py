import grp
import json

# 결과를 저장할 딕셔너리
results = {
    "U-50": {
        "title": "관리자 그룹에 최소한의 계정 포함",
        "status": "",
        "description": {
            "good": "관리자 그룹에 불필요한 계정이 등록되어 있지 않은 경우",
            "bad": "관리자 그룹에 불필요한 계정이 등록되어 있는 경우",
        },
        "unnecessary_accounts": []
    }
}

# 필요한 계정 목록 정의
necessary_accounts = set(["root", "bin", "daemon", "adm", "lp", "sync", "shutdown", "halt", "ubuntu", "user"])

def check_admin_group_accounts():
    try:
        # 관리자 그룹의 멤버를 가져옵니다
        admin_group_members = grp.getgrnam("Administrators").gr_mem
    except KeyError:
        results["status"] = "오류"
        results["message"] = "Administrators 그룹을 찾을 수 없습니다."
        return
    
    # 불필요한 계정을 식별합니다
    for account in admin_group_members:
        if account not in necessary_accounts:
            results["unnecessary_accounts"].append(account)
    
    # 결과 상태 설정
    if results["unnecessary_accounts"]:
        results["status"] = "취약"
    else:
        results["status"] = "양호"

# 검사 수행
check_admin_group_accounts()

# 결과를 JSON 파일로 저장
with open('result.json', 'w', encoding='utf-8') as f:
    json.dump(results, f, ensure_ascii=False, indent=4)

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
