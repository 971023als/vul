#!/bin/python3

import os
import stat
import json

def check_shadow_file_ownership_and_permission():
    results = []
    shadow_file = "/etc/shadow"
    expected_permission = 0o400  # Octal notation

    try:
        file_stat = os.stat(shadow_file)
        owner_uid = file_stat.st_uid
        file_permission = stat.S_IMODE(file_stat.st_mode)
        owner_name = os.getpwuid(owner_uid).pw_name

        if owner_name != "root":
            results.append({
                "코드": "U-08",
                "진단 결과": "취약",
                "현황": "/etc/shadow 파일의 소유자가 root가 아님",
                "대응방안": "/etc/shadow 파일의 소유자를 root로 변경 권장",
                "결과": "경고"
            })
        else:
            results.append({
                "코드": "U-08",
                "진단 결과": "양호",
                "현황": "/etc/shadow 파일의 소유자가 root임",
                "대응방안": "현재 설정 유지",
                "결과": "정상"
            })

        if file_permission != expected_permission:
            results.append({
                "코드": "U-08",
                "진단 결과": "취약",
                "현황": f"/etc/shadow 파일의 권한이 {oct(file_permission)}로 설정됨, 400 권장",
                "대응방안": "/etc/shadow 파일의 권한을 400으로 설정 권장",
                "결과": "경고"
            })
        else:
            results.append({
                "코드": "U-08",
                "진단 결과": "양호",
                "현황": "/etc/shadow 파일의 권한이 적절함",
                "대응방안": "현재 설정 유지",
                "결과": "정상"
            })

    except FileNotFoundError:
        results.append({
            "코드": "U-08",
            "진단 결과": "정보",
            "현황": "/etc/shadow 파일을 찾을 수 없음",
            "대응방안": "/etc/shadow 파일의 존재 여부 확인 필요",
            "결과": "정보"
        })

    return results

def save_results_to_json(results, file_path):
    with open(file_path, 'w') as f:
        json.dump(results, f, ensure_ascii=False, indent=4)

def main():
    results = check_shadow_file_ownership_and_permission()
    save_results_to_json(results, "shadow_file_ownership_permission_check_result.json")
    print("'/etc/shadow' 파일 소유자 및 권한 설정 점검 결과를 shadow_file_ownership_permission_check_result.json 파일에 저장하였습니다.")

if __name__ == "__main__":
    main()
