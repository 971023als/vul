#!/usr/bin/env python3
import json
import os
import stat
import shutil

# 결과를 저장할 딕셔너리
results = {
    "U-65": {
        "title": "at 파일 소유자 및 권한 설정",
        "status": "",
        "description": {
            "good": "at 접근제어 파일의 소유자가 root이고, 권한이 640 이하인 경우",
            "bad": "at 접근제어 파일의 소유자가 root가 아니거나, 권한이 640 이하가 아닌 경우"
        },
        "details": []
    }
}

def check_at_command_and_file():
    # at 명령을 사용할 수 있는지 확인
    if shutil.which("at"):
        results["U-65"]["details"].append("at 명령을 사용할 수 있습니다.")
    else:
        results["U-65"]["details"].append("at 명령을 사용할 수 없습니다.")
        results["U-65"]["status"] = "양호"  # at 명령이 없으면 양호로 간주
    
    # at 관련 파일의 사용 권한을 확인
    at_dir = "/etc/at.allow"
    if os.path.isfile(at_dir):
        file_stat = os.stat(at_dir)
        permissions = stat.S_IMODE(file_stat.st_mode)
        owner_uid = file_stat.st_uid
        
        if owner_uid == 0 and permissions <= 0o640:
            results["U-65"]["details"].append(f"{at_dir} 파일의 권한이 640 이하이며, 소유자가 root입니다.")
            results["U-65"]["status"] = "양호"
        else:
            results["U-65"]["details"].append(f"{at_dir} 파일의 소유자가 root가 아니거나, 권한이 640 이하가 아닙니다.")
            results["U-65"]["status"] = "취약"
    else:
        results["U-65"]["details"].append(f"{at_dir} 파일이 존재하지 않습니다.")
        results["U-65"]["status"] = "양호"

check_at_command_and_file()

# 결과 파일에 JSON 형태로 저장
result_file = 'at_command_and_file_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
