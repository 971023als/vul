#!/usr/bin/env python3
import pwd
import json

# 결과를 저장할 딕셔너리
results = {
    "U-53": {
        "title": "사용자 shell 점검",
        "status": "",
        "description": {
            "good": "로그인이 필요하지 않은 계정에 /bin/false 또는 /sbin/nologin 쉘이 부여되지 않은 경우",
            "bad": "로그인이 필요하지 않은 계정에 /bin/false 또는 /sbin/nologin 쉘이 부여되어 있는 경우"
        },
        "good_details": [],
        "bad_details": []
    }
}

# 로그인이 필요하지 않은 계정 정의
no_login_users = [
    "daemon", "bin", "sys", "adm", "listen", 
    "nobody", "nobody4", "noaccess", "diag", 
    "operator", "games", "gopher"
]

# /etc/passwd에서 사용자 정보 가져오기
passwd_entries = pwd.getpwall()

for entry in passwd_entries:
    if entry.pw_name in no_login_users:
        user, shell = entry.pw_name, entry.pw_shell
        # "/bin/false" 또는 "/sbin/nologin"으로 설정되어 있지 않은 경우 양호
        if shell not in ["/bin/false", "/sbin/nologin"]:
            results["U-53"]["good_details"].append(f"사용자 {user} 셸이 {shell}로 설정됨")
        else:
            results["U-53"]["bad_details"].append(f"사용자 {user}의 셸이 /bin/false 또는 /sbin/nologin으로 설정되어 있습니다.")

# 결과 상태 업데이트
if results["U-53"]["bad_details"]:
    results["U-53"]["status"] = "취약"
else:
    results["U-53"]["status"] = "양호"

# 결과 파일에 JSON 형태로 저장
result_file = 'check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
