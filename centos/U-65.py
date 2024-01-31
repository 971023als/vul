#!/bin/python3

import subprocess
import os
import stat
import json

def check_at_command_availability():
    try:
        subprocess.check_output(['command', '-v', 'at'], stderr=subprocess.STDOUT)
        return True
    except subprocess.CalledProcessError:
        return False

def check_at_file_permissions():
    results = []
    at_dir = "/etc/at.allow"

    # Check if the at command is available
    if check_at_command_availability():
        info_result = "at 명령을 사용할 수 있습니다."
    else:
        info_result = "at 명령을 사용할 수 없습니다."
        results.append({
            "분류": "시스템 설정",
            "코드": "U-65",
            "위험도": "낮음",
            "진단 항목": "at 파일 소유자 및 권한 설정",
            "진단 결과": "양호",
            "현황": info_result,
            "대응방안": "at 명령 사용 불가",
            "결과": "정상"
        })
        return results

    # Check the permission of the at related file
    if os.path.isfile(at_dir):
        permission = oct(os.stat(at_dir).st_mode)[-3:]
        if int(permission, 8) <= 640:
            perm_result = "관련 파일의 권한이 640 이하입니다."
            perm_status = "양호"
        else:
            perm_result = "관련 파일의 권한이 640 이상입니다."
            perm_status = "취약"
    else:
        perm_result = "관련 파일이 존재하지 않습니다."
        perm_status = "정보"

    results.append({
        "분류": "시스템 설정",
        "코드": "U-65",
        "위험도": "높음" if perm_status == "취약" else "낮음",
        "진단 항목": "at 파일 소유자 및 권한 설정",
        "진단 결과": perm_status,
        "현황": perm_result,
        "대응방안": "at 접근제어 파일 권한 조정 권장" if perm_status == "취약" else "현재 상태 유지",
        "결과": "경고" if perm_status == "취약" else "정상"
    })

    return results

def save_results_to_json(results, file_path):
    with open(file_path, 'w') as f:
        json.dump(results, f, ensure_ascii=False, indent=4)

def main():
    results = check_at_file_permissions()
    save_results_to_json(results, "at_file_permissions_check_result.json")
    print("at 파일 소유자 및 권한 설정 점검 결과를 at_file_permissions_check_result.json 파일에 저장하였습니다.")

if __name__ == "__main__":
    main()
