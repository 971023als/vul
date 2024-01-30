import re
import json

# 결과를 저장할 딕셔너리
results = {
    "U-39": {
        "title": "Apache 링크 사용 금지",
        "status": "",
        "description": {
            "good": "심볼릭 링크, aliases 사용을 제한한 경우",
            "bad": "심볼릭 링크, aliases 사용을 제한하지 않은 경우",
        },
        "message": ""
    }
}

def check_apache_link_restrictions(config_file="/etc/apache2/apache2.conf"):
    try:
        with open(config_file, 'r') as file:
            content = file.read()
            # "Options FollowSymLinks" 및 "Options SymLinksIfOwnerMatch" 설정을 검색합니다.
            symlink_result = re.search(r'^\s*Options\s+.*FollowSymLinks', content, re.MULTILINE)
            alias_result = re.search(r'^\s*Options\s+.*SymLinksIfOwnerMatch', content, re.MULTILINE)

            if symlink_result and alias_result:
                results["status"] = "취약"
                results["message"] = "Apache에서 심볼릭 링크 및 별칭이 허용됩니다."
            else:
                results["status"] = "양호"
                results["message"] = "Apache에서 심볼릭 링크 및 별칭 사용이 제한됩니다."
    except FileNotFoundError:
        results["status"] = "오류"
        results["message"] = f"{config_file} 파일을 찾을 수 없습니다."

# 검사 수행
check_apache_link_restrictions()

# 결과를 JSON 파일로 저장
with open('result.json', 'w', encoding='utf-8') as f:
    json.dump(results, f, ensure_ascii=False, indent=4)

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
