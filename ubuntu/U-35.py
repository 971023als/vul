import re
import json

# 결과를 저장할 딕셔너리
results = {
    "U-35": {
        "title": "Apache 디렉터리 리스팅 제거",
        "status": "",
        "description": {
            "good": "디렉터리 검색 기능을 사용하지 않는 경우",
            "bad": "디렉터리 검색 기능을 사용하는 경우",
        },
        "message": ""
    }
}

def check_apache_directory_listing(config_file="/etc/apache2/apache2.conf"):
    try:
        with open(config_file, 'r') as file:
            content = file.read()
            # "Options Indexes" 패턴을 검색합니다.
            if re.search(r'^\s*Options\s+Indexes', content, re.MULTILINE):
                results["status"] = "취약"
                results["message"] = "Apache 서버에서 디렉터리 목록이 사용 가능합니다."
            else:
                results["status"] = "양호"
                results["message"] = "Apache 서버에서 디렉터리 목록이 사용 가능하지 않습니다."
    except FileNotFoundError:
        results["status"] = "오류"
        results["message"] = f"{config_file} 파일을 찾을 수 없습니다."

# 검사 수행
check_apache_directory_listing()

# 결과를 JSON 파일로 저장
with open('result.json', 'w', encoding='utf-8') as f:
    json.dump(results, f, ensure_ascii=False, indent=4)

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
