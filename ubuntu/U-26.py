import subprocess
import json

# 결과를 저장할 딕셔너리
results = {
    "U-26": {
        "title": "automountd 제거 '확인 필요'",
        "status": "",
        "description": {
            "good": "automountd 서비스가 비활성화 되어있는 경우",
            "bad": "automountd 서비스가 활성화 되어있는 경우",
        },
        "message": ""
    }
}

def check_automountd_service():
    try:
        # automountd 서비스의 실행 여부 확인
        process = subprocess.run(['ps', '-ef'], stdout=subprocess.PIPE, text=True)
        output = process.stdout
        
        if "automount" in output:
            results["status"] = "취약"
            results["message"] = "Automount 서비스가 실행 중입니다."
        else:
            results["status"] = "양호"
            results["message"] = "Automount 서비스가 실행되고 있지 않습니다."
    except Exception as e:
        results["status"] = "오류"
        results["message"] = f"Automount 서비스 확인 중 오류 발생: {e}"

# 검사 수행
check_automountd_service()

# 결과를 JSON 파일로 저장
with open('result.json', 'w', encoding='utf-8') as f:
    json.dump(results, f, ensure_ascii=False, indent=4)

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
