import subprocess
import json

# 결과를 저장할 딕셔너리
results = {
    "U-28": {
        "title": "NIS, NIS+ 점검",
        "status": "",
        "description": {
            "good": "NIS 서비스가 비활성화 되어 있거나, 필요 시 NIS+를 사용하는 경우",
            "bad": "NIS 서비스가 활성화 되어 있는 경우",
        },
        "message": "",
        "processes": []
    }
}

def check_nis_services():
    # NIS 관련 서비스 목록
    services = ["ypserv", "ypbind", "ypxfrd", "rpc.yppasswdd", "rpc.ypupdated"]
    pattern = "|".join(services)

    try:
        # NIS 서비스의 실행 여부 확인
        result = subprocess.run(["ps", "-ef"], capture_output=True, text=True)
        output = result.stdout
        found_services = []

        for line in output.splitlines():
            if any(service in line for service in services):
                found_services.append(line.strip())

        if found_services:
            results["status"] = "취약"
            results["message"] = "NIS 서비스가 활성화되어 있습니다."
            results["processes"] = found_services
        else:
            results["status"] = "양호"
            results["message"] = "NIS 서비스가 비활성화되었습니다."
    except Exception as e:
        results["status"] = "오류"
        results["message"] = f"NIS 서비스 확인 중 오류 발생: {e}"

# 검사 수행
check_nis_services()

# 결과를 JSON 파일로 저장
with open('result.json', 'w', encoding='utf-8') as f:
    json.dump(results, f, ensure_ascii=False, indent=4)

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
