import json

# 결과를 저장할 딕셔너리
results = {
    "U-44": {
        "title": "root 이외의 UID가 '0' 금지",
        "status": "",
        "description": {
            "good": "root 계정과 동일한 UID를 갖는 계정이 존재하지 않는 경우",
            "bad": "root 계정과 동일한 UID를 갖는 계정이 존재하는 경우",
        },
        "details": []
    }
}

def check_root_uid():
    with open('/etc/passwd', 'r') as f:
        for line in f:
            parts = line.split(':')
            if len(parts) > 2 and parts[2] == '0' and parts[0] != 'root':
                results["status"] = "취약"
                results["details"].append(f"계정명: {parts[0]}, UID: {parts[2]}")
                
    if not results["details"]:
        results["status"] = "양호"
        results["description"]["good"] += " 모든 확인된 계정이 적절한 UID 값을 가지고 있습니다."
    else:
        results["description"]["bad"] += " 다음 계정이 root와 동일한 UID(0)를 가집니다: " + ", ".join(results["details"])

# 검사 수행
check_root_uid()

# 결과를 JSON 파일로 저장
with open('result.json', 'w', encoding='utf-8') as f:
    json.dump(results, f, ensure_ascii=False, indent=4)

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
