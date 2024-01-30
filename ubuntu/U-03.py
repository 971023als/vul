import json

# 결과를 저장할 딕셔너리
results = {
    "U-03": {
        "title": "계정 잠금 임계값 설정",
        "status": "",
        "description": {
            "good": "계정 잠금 임계값이 10회 이하의 값으로 설정되어 있는 경우",
            "bad": "계정 잠금 임계값이 설정되어 있지 않거나, 10회 이하의 값으로 설정되지 않은 경우"
        },
        "message": ""
    }
}

def check_account_lock_threshold():
    pam_file = "/etc/pam.d/common-auth"
    expected_setting = "auth required pam_tally2.so deny=10 unlock_time=900"
    try:
        with open(pam_file) as f:
            content = f.read()
            if expected_setting in content:
                results["U-03"]["status"] = "양호"
                results["U-03"]["message"] = "auth required pam_tally2.so deny=10 unlock_time=900 설정이 존재함."
            else:
                results["U-03"]["status"] = "취약"
                results["U-03"]["message"] = "auth required pam_tally2.so deny=10 unlock_time=900 설정이 없음."
    except FileNotFoundError:
        results["U-03"]["status"] = "오류"
        results["U-03"]["message"] = f"{pam_file} 파일을 찾을 수 없습니다."

# 검사 수행
check_account_lock_threshold()

# 결과를 JSON 파일로 저장
with open('U-03.json', 'w', encoding='utf-8') as f:
    json.dump(results, f, ensure_ascii=False, indent=4)

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
