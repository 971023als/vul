import os
import subprocess
import json

# 결과를 저장할 딕셔너리
results = {
    "U-38": {
        "title": "Apache 불필요한 파일 제거",
        "status": "",
        "description": {
            "good": "매뉴얼 파일 및 디렉터리가 제거되어 있는 경우",
            "bad": "매뉴얼 파일 및 디렉터리가 제거되지 않은 경우",
        },
        "items": []
    }
}

def check_unwanted_files():
    httpd_root = "/etc/apache2"  # Apache 설정 파일 위치 수정 필요
    unwanted_items = ["manual", "samples", "docs"]
    apache_running = subprocess.run(["pgrep", "-f", "apache2"], capture_output=True).returncode == 0

    if apache_running:
        for item in unwanted_items:
            item_path = os.path.join(httpd_root, item)
            if not os.path.exists(item_path):
                results["items"].append(f"{item}을(를) {httpd_root}에서 찾을 수 없습니다.")
            else:
                results["status"] = "취약"
                results["items"].append(f"{item}을(를) {httpd_root}에서 찾을 수 있습니다.")
    else:
        results["status"] = "정보"
        results["items"].append("아파치가 실행되지 않습니다.")

    if not results["status"]:
        results["status"] = "양호"

# 검사 수행
check_unwanted_files()

# 결과를 JSON 파일로 저장
with open('result.json', 'w', encoding='utf-8') as f:
    json.dump(results, f, ensure_ascii=False, indent=4)

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
