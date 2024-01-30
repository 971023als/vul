#!/usr/bin/env python3
import json
import subprocess

# 결과를 저장할 딕셔너리
results = {
    "U-40": {
        "title": "Apache 파일 업로드 및 다운로드 제한",
        "status": "",
        "description": {
            "good": "파일 업로드 및 다운로드를 제한한 경우",
            "bad": "파일 업로드 및 다운로드를 제한하지 않은 경우"
        },
        "details": []
    }
}

# Apache 구성 파일 경로 설정
config_file = "/etc/httpd/conf/httpd.conf"

def check_file_transfer_restrictions():
    # 구성 파일에서 업로드 및 다운로드 제한 옵션 검사
    upload_result = subprocess.run(["grep", "-E", "^[ \t]*LimitRequestBody", config_file], capture_output=True, text=True)
    download_result = subprocess.run(["grep", "-E", "^[ \t]*LimitXMLRequestBody", config_file], capture_output=True, text=True)
    upload_size_result = subprocess.run(["grep", "-E", "^[ \t]*LimitUploadSize", config_file], capture_output=True, text=True)

    if upload_result.returncode == 0 or download_result.returncode == 0 or upload_size_result.returncode == 0:
        results["U-40"]["status"] = "양호"
        results["U-40"]["details"].append("Apache에서 파일 업로드 및 다운로드가 제한됩니다.")
    else:
        results["U-40"]["status"] = "취약"
        results["U-40"]["details"].append("Apache에서 파일 업로드 및 다운로드가 제한되지 않습니다.")

check_file_transfer_restrictions()

# 결과 파일에 JSON 형태로 저장
result_file = 'apache_file_transfer_restriction_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
