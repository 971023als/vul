import subprocess
import datetime
import json

# 결과를 저장할 딕셔너리
results = {
    "U-42": {
        "title": "최신 보안패치 및 벤더 권고사항 적용",
        "status": "",
        "description": {
            "good": "패치 적용 정책을 수립하여 주기적으로 패치를 관리하고 있는 경우",
            "bad": "패치 적용 정책을 수립하지 않고 주기적으로 패치관리를 하지 않는 경우",
        },
        "message": ""
    }
}

def check_patch_management():
    # 현재 날짜 가져오기
    current_date = datetime.datetime.now().strftime('%Y-%m-%d')
    patch_log_file = "/var/log/patch.log"

    # /var/log/patch.log에서 현재 날짜에 설치된 패치 검색
    try:
        result = subprocess.run(["grep", f"Patches installed on {current_date}", patch_log_file], capture_output=True, text=True)
        if result.returncode == 0:
            results["status"] = "양호"
            results["message"] = f"'{current_date}에 설치된 패치' 행이 {patch_log_file}에 있습니다."
        else:
            results["status"] = "취약"
            results["message"] = f"'{current_date}에 설치된 패치' 행이 {patch_log_file}에 없습니다."
    except Exception as e:
        results["status"] = "오류"
        results["message"] = str(e)

# 검사 수행
check_patch_management()

# 결과를 JSON 파일로 저장
with open('result.json', 'w', encoding='utf-8') as f:
    json.dump(results, f, ensure_ascii=False, indent=4)

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
