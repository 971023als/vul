import re
import json

# 결과를 저장할 딕셔너리
results = {
    "U-40": {
        "title": "Apache 파일 업로드 및 다운로드 제한",
        "status": "",
        "description": {
            "good": "파일 업로드 및 다운로드를 제한한 경우",
            "bad": "파일 업로드 및 다운로드를 제한하지 않은 경우",
        },
        "message": ""
    }
}

def check_apache_file_restrictions(config_file="/etc/apache2/apache2.conf"):
    try:
        with open(config_file, 'r') as file:
            content = file.read()
            # 파일 업로드 및 다운로드 제한 설정을 검색합니다.
            upload_result = re.search(r'^\s*LimitRequestBody', content, re.MULTILINE)
            download_result = re.search(r'^\s*LimitXMLRequestBody', content, re.MULTILINE)
            upload_size_result = re.search(r'^\s*LimitUploadSize', content, re.MULTILINE)

            if upload_result or download_result or upload_size_result:
                results["status"] = "양호"
                results["message"] = "Apache에서 파일 업로드 및 다운로드가 제한됩니다."
            else:
                results["status"] = "취약"
                results["message"] = "Apache에서 파일 업로드 및 다운로드가 제한되지 않습니다."
    except FileNotFoundError:
        results["status"] = "오류"
        results["message"] = f"{config_file} 파일을 찾을 수 없습니다."

# 검사 수행
check_apache_file_restrictions()

# 결과를 JSON 파일로 저장
with open('result.json', 'w', encoding='utf-8') as f:
    json.dump(results, f, ensure_ascii=False, indent=4)

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
