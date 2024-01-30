#!/usr/bin/env python3
import json
import subprocess

# 결과를 저장할 딕셔너리
results = {
    "U-37": {
        "title": "Apache 상위 디렉터리 접근 금지",
        "status": "",
        "description": {
            "good": "상위 디렉터리에 이동 제한을 설정한 경우",
            "bad": "상위 디렉터리에 이동 제한을 설정하지 않은 경우"
        },
        "details": []
    }
}

HTTPD_CONF_FILE = "/etc/httpd/conf/httpd.conf"
ALLOW_OVERRIDE_OPTION = "AllowOverride AuthConfig"

def check_directory_access_restriction():
    try:
        if not subprocess.run(["test", "-f", HTTPD_CONF_FILE]).returncode == 0:
            results["U-37"]["details"].append(f"{HTTPD_CONF_FILE} 파일을 찾을 수 없습니다.")
            results["U-37"]["status"] = "정보"
        else:
            process = subprocess.run(["grep", ALLOW_OVERRIDE_OPTION, HTTPD_CONF_FILE], capture_output=True, text=True)
            if process.returncode == 0:
                results["U-37"]["status"] = "양호"
                results["U-37"]["details"].append(f"{HTTPD_CONF_FILE}에서 {ALLOW_OVERRIDE_OPTION} 옵션을 찾았습니다.")
            else:
                results["U-37"]["status"] = "취약"
                results["U-37"]["details"].append(f"{HTTPD_CONF_FILE}에서 {ALLOW_OVERRIDE_OPTION} 옵션을 찾을 수 없습니다.")
    except Exception as e:
        results["U-37"]["details"].append(f"Apache 설정 파일 검사 중 오류 발생: {e}")

check_directory_access_restriction()

# 결과 파일에 JSON 형태로 저장
result_file = 'apache_directory_access_restriction_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
