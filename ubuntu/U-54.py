#!/usr/bin/env python3
import json

# 결과를 저장할 딕셔너리
results = {
    "U-54": {
        "title": "Session Timeout 설정",
        "status": "",
        "description": {
            "good": "Session Timeout이 600초(10분) 이하로 설정되어 있는 경우",
            "bad": "Session Timeout이 600초(10분) 이하로 설정되지 않은 경우"
        },
        "details": []
    }
}

def check_session_timeout():
    try:
        with open('/etc/profile', 'r') as file:
            for line in file:
                if "TMOUT=600" in line:
                    results["U-54"]["status"] = "양호"
                    results["U-54"]["details"].append("/etc/profile에서 TMOUT가 600으로 설정됨")
                    return
    except FileNotFoundError:
        results["U-54"]["details"].append("/etc/profile 파일을 찾을 수 없습니다.")

    # TMOUT=600 설정이 없는 경우
    results["U-54"]["status"] = "취약"
    results["U-54"]["details"].append("/etc/profile에서 TMOUT가 600으로 설정되지 않음")

check_session_timeout()

# 결과 파일에 JSON 형태로 저장
result_file = 'session_timeout_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
