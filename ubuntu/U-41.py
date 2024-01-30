import re
import json

# 결과를 저장할 딕셔너리
results = {
    "U-41": {
        "title": "Apache 웹 서비스 영역의 분리",
        "status": "",
        "description": {
            "good": "DocumentRoot를 별도의 디렉터리로 지정한 경우",
            "bad": "DocumentRoot를 기본 디렉터리로 지정한 경우",
        },
        "message": ""
    }
}

def check_document_root_separation(config_file="/etc/apache2/sites-available/000-default.conf"):
    default_document_root = "/var/www/html"
    try:
        with open(config_file, 'r') as file:
            content = file.read()
            document_root_search = re.search(r'DocumentRoot\s+"([^"]+)"', content)
            if document_root_search:
                document_root = document_root_search.group(1)
                if document_root == default_document_root:
                    results["status"] = "취약"
                    results["message"] = f"DocumentRoot가 기본 경로로 설정되었습니다: {default_document_root}"
                else:
                    results["status"] = "양호"
                    results["message"] = "DocumentRoot가 기본 경로로 설정되지 않았습니다."
            else:
                results["status"] = "오류"
                results["message"] = "DocumentRoot 설정을 찾을 수 없습니다."
    except FileNotFoundError:
        results["status"] = "오류"
        results["message"] = f"{config_file} 파일을 찾을 수 없습니다."

# 검사 수행
check_document_root_separation()

# 결과를 JSON 파일로 저장
with open('result.json', 'w', encoding='utf-8') as f:
    json.dump(results, f, ensure_ascii=False, indent=4)

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
