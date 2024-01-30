import subprocess
import json

# 결과를 저장할 딕셔너리
results = {
    "U-24": {
        "title": "NFS 서비스 비활성화",
        "status": "",
        "description": {
            "good": "불필요한 NFS 서비스가 비활성화 되어있는 경우",
            "bad": "불필요한 NFS 서비스가 활성화 되어있는 경우",
        },
        "message": ""
    }
}

def check_nfs_service():
    try:
        # NFS 서비스 데몬(nfsd, statd, lockd)이 실행 중인지 확인
        process = subprocess.Popen(['ps', '-ef'], stdout=subprocess.PIPE)
        output, error = process.communicate()
        if error:
            results["status"] = "오류"
            results["message"] = f"오류 발생: {error}"
            return
        
        services = ["nfsd", "statd", "lockd"]
        running_services = [service for service in services if service in output.decode('utf-8')]
        
        if running_services:
            results["status"] = "취약"
            results["message"] = f"NFS 서비스 데몬이 실행 중입니다: {', '.join(running_services)}"
        else:
            results["status"] = "양호"
            results["message"] = results["description"]["good"]
    except Exception as e:
        results["status"] = "오류"
        results["message"] = str(e)

# 검사 수행
check_nfs_service()

# 결과를 JSON 파일로 저장
with open('result.json', 'w', encoding='utf-8') as f:
    json.dump(results, f, ensure_ascii=False, indent=4)

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
