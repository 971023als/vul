#!/bin/python3

import os
import stat
import json

def check_nfs_config_permissions():
    results = []
    filename = "/etc/exports"

    if not os.path.exists(filename):
        results.append({
            "분류": "네트워크 서비스",
            "코드": "U-69",
            "위험도": "정보",
            "진단 항목": "NFS 설정파일 접근권한",
            "진단 결과": "정보",
            "현황": f"{filename} 가 존재하지 않습니다.",
            "대응방안": "NFS 설정 파일 생성 및 적절한 권한 설정 권장",
            "결과": "정보"
        })
    else:
        file_stat = os.stat(filename)
        owner = stat.filemode(file_stat.st_mode)
        permission = oct(file_stat.st_mode)[-3:]

        if os.getuid(file_stat.st_uid) != 0:  # UID 0 is root
            owner_status = "취약"
            owner_message = f"{filename} 의 소유자가 루트가 아닙니다."
        else:
            owner_status = "양호"
            owner_message = f"{filename} 의 소유자가 루트가 맞습니다."

        if int(permission, 8) > 644:
            perm_status = "취약"
            perm_message = f"{filename} 의 권한이 644보다 큽니다."
        else:
            perm_status = "양호"
            perm_message = f"{filename} 의 권한이 644 이하입니다."

        results.append({
            "분류": "네트워크 서비스",
            "코드": "U-69",
            "위험도": "높음" if owner_status == "취약" or perm_status == "취약" else "낮음",
            "진단 항목": "NFS 설정파일 접근권한",
            "진단 결과": ", ".join([owner_status, perm_status]),
            "현황": ", ".join([owner_message, perm_message]),
            "대응방안": "소유자를 root로 변경 및 권한을 644 이하로 설정 권장",
            "결과": "경고" if owner_status == "취약" or perm_status == "취약" else "정상"
        })

    return results

def save_results_to_json(results, file_path):
    with open(file_path, 'w') as f:
        json.dump(results, f, ensure_ascii=False, indent=4)

def main():
    results = check_nfs_config_permissions()
    save_results_to_json(results, "nfs_config_permissions_check_result.json")
    print("NFS 설정파일 접근권한 점검 결과를 nfs_config_permissions_check_result.json 파일에 저장하였습니다.")

if __name__ == "__main__":
    main()
