#!/usr/bin/env python3
import json
import os
import subprocess

# 결과를 저장할 딕셔너리
results = {
    "U-38": {
        "title": "Apache 불필요한 파일 제거",
        "status": "",
        "description": {
            "good": "매뉴얼 파일 및 디렉터리가 제거되어 있는 경우",
            "bad": "매뉴얼 파일 및 디렉터리가 제거되지 않은 경우"
        },
        "details": []
    }
}

# Apache HTTPD 구성 파일 경로
httpd_root = "/etc/httpd"  # 예시 경로, 실제 환경에 맞게 조정 필요
unwanted_items = ["manual", "samples", "docs"]

def check_apache_unwanted_files():
    if subprocess.run(["pgrep", "-f", "httpd"], capture_output=True).returncode != 0:
        results["U-38"]["details"].append("Apache가 실행되지 않습니다.")
        results["U-38"]["status"] = "정보"
    else:
        found_unwanted = False
        for item in unwanted_items:
            item_path = os.path.join(httpd_root, item)
            if os.path.exists(item_path):
                found_unwanted = True
                results["U-38"]["details"].append(f"{item}이(가) {httpd_root}에 존재합니다.")
        if not found_unwanted:
            results["U-38"]["status"] = "양호"
        else:
            results["U-38"]["status"] = "취약"

check_apache_unwanted_files()

# 결과 파일에 JSON 형태로 저장
result_file = 'apache_unwanted_files_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
