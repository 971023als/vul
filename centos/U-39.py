#!/usr/bin/env python3
import json
import subprocess

# 결과를 저장할 딕셔너리
results = {
    "U-39": {
        "title": "Apache 링크 사용 금지",
        "status": "",
        "description": {
            "good": "심볼릭 링크, aliases 사용을 제한한 경우",
            "bad": "심볼릭 링크, aliases 사용을 제한하지 않은 경우"
        },
        "details": []
    }
}

# Apache 구성 파일 경로 설정
config_file = "/etc/httpd/conf/httpd.conf"

def check_apache_link_restrictions():
    try:
        # 구성 파일에서 FollowSymLinks 옵션 검사
        symlink_result = subprocess.run(["grep", "-E", "^[ \t]*Options[ \t]+FollowSymLinks", config_file], capture_output=True, text=True)
        # 구성 파일에서 SymLinksIfOwnerMatch 옵션 검사
        alias_result = subprocess.run(["grep", "-E", "^[ \t]*Options[ \t]+SymLinksIfOwnerMatch", config_file], capture_output=True, text=True)

        if symlink_result.returncode == 0 and alias_result.returncode == 0:
            results["U-39"]["status"] = "취약"
            results["U-39"]["details"].append("Apache에서 심볼릭 링크 및 별칭 사용이 허용됩니다.")
        else:
            results["U-39"]["status"] = "양호"
            results["U-39"]["details"].append("Apache에서는 심볼릭 링크 및 별칭 사용이 제한됩니다.")
    except Exception as e:
        results["U-39"]["details"].append(f"Apache 링크 사용 설정 검사 중 오류 발생: {e}")

check_apache_link_restrictions()

# 결과 파일에 JSON 형태로 저장
result_file = 'apache_link_restriction_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
