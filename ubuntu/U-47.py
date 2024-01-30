import subprocess
import json

# 결과를 저장할 딕셔너리
results = {
    "U-47": {
        "title": "패스워드 최대 사용기간 설정",
        "status": "",
        "description": {
            "good": "패스워드 최대 사용기간이 90일(12주) 이하로 설정되어 있는 경우",
            "bad": "패스워드 최대 사용기간이 90일(12주) 이하로 설정되어 있지 않은 경우",
        },
        "message": ""
    }
}

def check_password_max_age():
    try:
        # /etc/login.defs 파일에서 PASS_MAX_DAYS 값을 가져옵니다
        result = subprocess.run(["grep", "^PASS_MAX_DAYS", "/etc/login.defs"], capture_output=True, text=True)
        if result.stdout:
            pass_max_days = int(result.stdout.split()[1])
            if pass_max_days <= 90:
                results["status"] = "양호"
                results["message"] = f"패스워드 최대 사용기간이 {pass_max_days}일로 설정되어 있습니다."
            else:
                results["status"] = "취약"
                results["message"] = f"패스워드 최대 사용기간이 90일 이하로 설정되어 있지 않습니다. 현재 설정: {pass_max_days}일."
        else:
            results["status"] = "정보"
            results["message"] = "PASS_MAX_DAYS 설정을 찾을 수 없습니다."
    except Exception as e:
        results["status"] = "오류"
        results["message"] = f"패스워드 최대 사용기간 설정 검사 중 오류 발생: {e}"

# 검사 수행
check_password_max_age()

# 결과를 JSON 파일로 저장
with open('result.json', 'w', encoding='utf-8') as f:
    json.dump(results, f, ensure_ascii=False, indent=4)

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
