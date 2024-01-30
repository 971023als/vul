#!/usr/bin/env python3
import json
import subprocess

# 결과를 저장할 딕셔너리
results = {
    "U-44": {
        "title": "root 이외의 UID가 '0' 금지",
        "status": "",
        "description": {
            "good": "root 계정과 동일한 UID를 갖는 계정이 존재하지 않는 경우",
            "bad": "root 계정과 동일한 UID를 갖는 계정이 존재하는 경우"
        },
        "details": []
    }
}

def check_non_root_uid_zero():
    # /etc/passwd에서 UID가 0인 계정 찾기
    try:
        command = ["awk", "-F:", '$3=="0"{print $1":"$3}', "/etc/passwd"]
        process = subprocess.run(command, capture_output=True, text=True)
        uid_zero_accounts = process.stdout.strip().split('\n')

        if len(uid_zero_accounts) > 1:
            results["U-44"]["status"] = "취약"
            results["U-44"]["details"].extend(uid_zero_accounts)
        else:
            results["U-44"]["status"] = "양호"
    except Exception as e:
        results["U-44"]["details"].append(f"UID '0' 계정 검사 중 오류 발생: {e}")

check_non_root_uid_zero()

# 결과 파일에 JSON 형태로 저장
result_file = 'non_root_uid_zero_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
