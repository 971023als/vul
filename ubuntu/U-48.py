import subprocess
import json

# 결과를 저장할 딕셔너리
results = {
    "U-48": {
        "title": "패스워드 최소 사용기간 설정",
        "status": "",
        "description": {
            "good": "패스워드 최소 사용기간이 1일(1주)로 설정되어 있는 경우",
            "bad": "패스워드 최소 사용기간이 설정되어 있지 않는 경우",
        },
        "message": ""
    }
}

def check_password_min_age():
    try:
        # /etc/login.defs 파일에서 PASS_MIN_DAYS 값을 가져옵니다
        result = subprocess.run(["grep", "^PASS_MIN_DAYS", "/etc/login.defs"], capture_output=True, text=True)
        if result.stdout:
            pass_min_days = int(result.stdout.split()[1])
            if pass_min_days >= 1:
                results["status"] = "양호"
                results["message"] = f"패스워드 최소 사용기간이 {pass_min_days}일로 설정되어 있습니다."
            else:
                results["status"] = "취약"
                results["message"] = "패스워드 최소 사용기간이 1일 이상으로 설정되어 있지 않습니다."
        else:
            results["status"] = "취약"
            results["message"] = "PASS_MIN_DAYS 설정을 찾을 수 없습니다."
    except Exception as e:
        results["status"] = "오류"
        results["message"] = f"패스워드 최소 사용기간 설정 검사 중 오류 발생: {e}"

# 검사 수행
check_password_min_age()

# 결과를 JSON 파일로 저장
with open('result.json', 'w', encoding='utf-8') as f:
    json.dump(results, f, ensure_ascii=False, indent=4)

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
