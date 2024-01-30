#!/usr/bin/env python3
import json
import subprocess

# 결과를 저장할 딕셔너리
results = {
    "U-41": {
        "title": "Apache 웹 서비스 영역의 분리",
        "status": "",
        "description": {
            "good": "DocumentRoot를 별도의 디렉터리로 지정한 경우",
            "bad": "DocumentRoot를 기본 디렉터리로 지정한 경우"
        },
        "details": []
    }
}

# Apache 구성 파일 경로 설정
config_file = "/etc/httpd/conf/httpd.conf"
default_directory = "/var/www/html"  # 이 값은 환경에 따라 달라질 수 있습니다.

def check_document_root():
    try:
        # DocumentRoot 설정 값 추출
        command = ["grep", "DocumentRoot", config_file]
        process = subprocess.run(command, capture_output=True, text=True)
        if process.returncode == 0:
            document_root = process.stdout.split()[1].strip('"')
            if document_root == default_directory:
                results["U-41"]["status"] = "취약"
                results["U-41"]["details"].append(f"DocumentRoot가 기본 경로로 설정되었습니다: {document_root}")
            else:
                results["U-41"]["status"] = "양호"
                results["U-41"]["details"].append("DocumentRoot가 기본 경로로 설정되지 않았습니다.")
        else:
            results["U-41"]["details"].append("DocumentRoot 설정을 찾을 수 없습니다.")
    except Exception as e:
        results["U-41"]["details"].append(f"DocumentRoot 설정 검사 중 오류 발생: {e}")

check_document_root()

# 결과 파일에 JSON 형태로 저장
result_file = 'apache_document_root_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
