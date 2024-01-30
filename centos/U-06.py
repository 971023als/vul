#!/usr/bin/env python3
import json
import subprocess

# 결과를 저장할 딕셔너리
results = {
    "U-06": {
        "title": "파일 및 디렉토리 소유자 설정",
        "status": "",
        "description": {
            "good": "소유자가 존재하지 않은 파일 및 디렉터리가 존재하지 않는 경우",
            "bad": "소유자가 존재하지 않은 파일 및 디렉터리가 존재하는 경우"
        },
        "details": []
    }
}

def check_file_directory_ownership():
    try:
        invalid_owner_files = subprocess.check_output(['find', '/root/', '-nouser'], stderr=subprocess.DEVNULL, text=True).strip()
        
        if invalid_owner_files:
            results["U-06"]["status"] = "취약"
            results["U-06"]["details"].append("다음 파일 또는 디렉터리의 소유자가 의심됩니다.")
            results["U-06"]["details"].extend(invalid_owner_files.split('\n'))
        else:
            results["U-06"]["status"] = "양호"
            results["U-06"]["details"].append("잘못된 소유자가 있는 파일 또는 디렉터리를 찾을 수 없습니다.")
    except subprocess.SubprocessError as e:
        results["U-06"]["details"].append(f"검사 중 오류 발생: {e}")

check_file_directory_ownership()

# 결과 파일에 JSON 형태로 저장
result_file = 'file_directory_ownership_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
