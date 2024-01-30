import re
import json

# 결과를 저장할 딕셔너리
results = {
    "U-25": {
        "title": "NFS 서비스 접근 통제 '확인 필요'",
        "status": "",
        "description": {
            "good": "불필요한 NFS 서비스가 비활성화 되어있는 경우",
            "bad": "불필요한 NFS 서비스가 활성화 되어있는 경우",
        },
        "message": ""
    }
}

def check_nfs_access_control():
    try:
        with open('/etc/exports', 'r') as file:
            content = file.read()
            # 'everyone' 그룹에 대해 'no_root_squash' 옵션이 없는 경우를 찾습니다.
            if re.search(r'^[^#].*\severyone(?!.*no_root_squash)', content, re.MULTILINE):
                results["status"] = "취약"
                results["message"] = "NFS는 '모두' 그룹에 대한 제한 없이 수출을 공유하고 있습니다."
            else:
                results["status"] = "양호"
                results["message"] = "NFS는 '모두' 그룹에 대한 제한 없이 수출을 공유하지 않습니다."
    except FileNotFoundError:
        results["status"] = "오류"
        results["message"] = "/etc/exports 파일을 찾을 수 없습니다."

# 검사 수행
check_nfs_access_control()

# 결과를 JSON 파일로 저장
with open('result.json', 'w', encoding='utf-8') as f:
    json.dump(results, f, ensure_ascii=False, indent=4)

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
