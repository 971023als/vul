#!/usr/bin/env python3
import json
import subprocess

# 결과를 저장할 딕셔너리
results = {
    "U-24": {
        "title": "NFS 서비스 비활성화",
        "status": "",
        "description": {
            "good": "불필요한 NFS 서비스가 비활성화 되어있는 경우",
            "bad": "불필요한 NFS 서비스가 활성화 되어있는 경우"
        },
        "details": []
    }
}

def check_nfs_services():
    try:
        # NFS 서비스 데몬이 실행 중인지 확인
        process = subprocess.run(["pgrep", "-f", "nfsd|statd|lockd"], capture_output=True, text=True)
        if process.returncode == 0:
            results["U-24"]["status"] = "취약"
            results["U-24"]["details"].append("NFS 서비스 데몬이 실행 중입니다.")
        else:
            results["U-24"]["status"] = "양호"
            results["U-24"]["details"].append("NFS 서비스 데몬이 실행되고 있지 않습니다.")
    except Exception as e:
        results["U-24"]["details"].append(f"NFS 서비스 검사 중 오류 발생: {e}")
        results["U-24"]["status"] = "정보"

check_nfs_services()

# 결과 파일에 JSON 형태로 저장
result_file = 'nfs_service_disable_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
