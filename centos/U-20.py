#!/usr/bin/env python3
import json
import subprocess

# 결과를 저장할 딕셔너리
results = {
    "U-20": {
        "title": "Anonymous FTP 비활성화",
        "status": "",
        "description": {
            "good": "Anonymous FTP (익명 ftp) 접속을 차단한 경우",
            "bad": "Anonymous FTP (익명 ftp) 접속을 차단하지 않은 경우"
        },
        "details": []
    }
}

def check_anonymous_ftp():
    try:
        # /etc/passwd에서 "ftp" 계정 존재 여부 확인
        process = subprocess.run(["grep", "ftp", "/etc/passwd"], capture_output=True, text=True)
        if process.returncode == 0:
            results["U-20"]["status"] = "취약"
            results["U-20"]["details"].append("FTP 계정이 /etc/passwd 파일에 있습니다.")
        else:
            results["U-20"]["status"] = "양호"
            results["U-20"]["details"].append("FTP 계정이 /etc/passwd 파일에 없습니다.")
    except Exception as e:
        results["U-20"]["details"].append(f"Anonymous FTP 점검 중 오류 발생: {e}")
        results["U-20"]["status"] = "정보"

check_anonymous_ftp()

# 결과 파일에 JSON 형태로 저장
result_file = 'anonymous_ftp_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
