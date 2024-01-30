import re
import json

# 결과를 저장할 딕셔너리
results = {
    "U-37": {
        "title": "Apache 상위 디렉터리 접근 금지",
        "status": "",
        "description": {
            "good": "상위 디렉터리에 이동제한을 설정한 경우",
            "bad": "상위 디렉터리에 이동제한을 설정하지 않은 경우",
        },
        "message": ""
    }
}

def check_apache_directory_access_restriction(config_file="/etc/apache2/apache2.conf"):
    try:
        with open(config_file, 'r') as file:
            content = file.read()
            # "AllowOverride AuthConfig" 설정을 검색합니다.
            if re.search(r'AllowOverride\s+AuthConfig', content):
                results["status"] = "양호"
                results["message"] = f"{config_file}에서 'AllowOverride AuthConfig'를 찾았습니다."
            else:
                results["status"] = "취약"
                results["message"] = f"{config_file}에서 'AllowOverride AuthConfig'를 찾을 수 없습니다."
    except FileNotFoundError:
        results["status"] = "오류"
        results["message"] = f"{config_file} 파일을 찾을 수 없습니다."

# 검사 수행
check_apache_directory_access_restriction()

# 결과를 JSON 파일로 저장
with open('result.json', 'w', encoding='utf-8') as f:
    json.dump(results, f, ensure_ascii=False, indent=4)

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
