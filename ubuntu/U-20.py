import subprocess
import json

# 결과를 저장할 딕셔너리
results = {
    "U-20": {
        "title": "Anonymous FTP 비활성화",
        "status": "",
        "description": {
            "good": "Anonymous FTP (익명 ftp) 접속을 차단한 경우",
            "bad": "Anonymous FTP (익명 ftp) 접속을 차단하지 않은 경우",
        },
        "message": ""
    }
}

def check_anonymous_ftp():
    # /etc/passwd 파일에서 'ftp' 계정 존재 여부 확인
    try:
        result = subprocess.run(["grep", "ftp", "/etc/passwd"], capture_output=True, text=True)
        if result.stdout:
            results["U-20"]["status"] = "취약"
            results["U-20"]["message"] = results["U-20"]["description"]["bad"]
        else:
            results["U-20"]["status"] = "양호"
            results["U-20"]["message"] = results["U-20"]["description"]["good"]
    except Exception as e:
        results["U-20"]["status"] = "오류"
        results["U-20"]["message"] = f"Anonymous FTP 계정 확인 중 오류 발생: {e}"

# 검사 수행
check_anonymous_ftp()

# 결과를 JSON 파일로 저장
with open('result.json', 'w', encoding='utf-8') as f:
    json.dump(results, f, ensure_ascii=False, indent=4)

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
