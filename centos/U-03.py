#!/usr/bin/env python3
import json
import re

# 결과를 저장할 딕셔너리
results = {
    "U-03": {
        "title": "계정 잠금 임계값 설정",
        "status": "",
        "description": {
            "good": "계정 잠금 임계값이 10회 이하의 값으로 설정되어 있는 경우",
            "bad": "계정 잠금 임계값이 설정되어 있지 않거나, 10회 이하의 값으로 설정되지 않은 경우"
        },
        "details": []
    }
}

def check_account_lock_threshold():
    pam_file = "/etc/pam.d/system-auth"
    try:
        with open(pam_file, 'r') as file:
            pam_content = file.read()
        
        if re.search(r"auth\s+required\s+pam_(tally2|faillock)\.so.*deny=([0-9]+).*", pam_content):
            matches = re.finditer(r"auth\s+required\s+pam_(tally2|faillock)\.so.*deny=([0-9]+).*", pam_content, re.MULTILINE)
            for match in matches:
                if int(match.group(2)) <= 10:
                    results["U-03"]["status"] = "양호"
                    results["U-03"]["details"].append(f"계정 잠금 임계값이 {match.group(2)}회로 적절히 설정되어 있습니다.")
                else:
                    results["U-03"]["status"] = "취약"
                    results["U-03"]["details"].append(f"계정 잠금 임계값이 {match.group(2)}회로 설정되어 있으나, 10회 이하로 설정되어야 합니다.")
        else:
            results["U-03"]["status"] = "취약"
            results["U-03"]["details"].append("계정 잠금 임계값이 설정되어 있지 않습니다.")
    except FileNotFoundError:
        results["U-03"]["details"].append(f"{pam_file} 파일이 존재하지 않습니다.")
        results["U-03"]["status"] = "정보"

check_account_lock_threshold()

# 결과 파일에 JSON 형태로 저장
result_file = 'account_lock_threshold_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
