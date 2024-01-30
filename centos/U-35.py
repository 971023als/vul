#!/usr/bin/env python3
import json
import subprocess

# 결과를 저장할 딕셔너리
results = {
    "U-35": {
        "title": "Apache 디렉터리 리스팅 제거",
        "status": "",
        "description": {
            "good": "디렉터리 검색 기능을 사용하지 않는 경우",
            "bad": "디렉터리 검색 기능을 사용하는 경우"
        },
        "details": []
    }
}

# Apache 구성 파일 경로 설정
config_file = "/etc/httpd/conf/httpd.conf"

def check_directory_listing():
    try:
        # grep을 사용하여 구성 파일에서 디렉터리 목록 설정을 확인합니다
        process = subprocess.run(["grep", "-E", "^[ \t]*Options[ \t]+Indexes", config_file], capture_output=True, text=True)
        if process.returncode == 0:
            results["U-35"]["status"] = "취약"
            results["U-35"]["details"].append("Apache 서버에서 디렉터리 목록이 사용 가능합니다.")
        else:
            results["U-35"]["status"] = "양호"
            results["U-35"]["details"].append("Apache 서버에서 디렉터리 목록이 사용 가능하지 않습니다.")
    except Exception as e:
        results["U-35"]["details"].append(f"Apache 디렉터리 리스팅 설정 검사 중 오류 발생: {e}")

check_directory_listing()

# 결과 파일에 JSON 형태로 저장
result_file = 'apache_directory_listing_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
