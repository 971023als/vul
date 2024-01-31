#!/bin/python3

import subprocess
import json

def check_suid_sgid_files():
    results = []
    # root 소유이며 SUID 또는 SGID 권한이 설정된 파일들을 찾습니다.
    command = ["find", "/", "-user", "root", "-type", "f", "\\(", "-perm", "-4000", "-o", "-perm", "-2000", "\\)", "-exec", "ls", "-l", "{}", ";"]
    try:
        proc = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        stdout, stderr = proc.communicate()
        files_with_permissions = stdout.decode().strip()

        if files_with_permissions:
            results.append({
                "코드": "U-13",
                "진단 결과": "취약",
                "현황": "주요 파일의 권한에 SUID와 SGID 설정이 부여되어 있음",
                "대응방안": "불필요한 SUID/SGID 설정 제거 권장",
                "결과": "경고",
                "탐지된 파일": files_with_permissions.split("\n")
            })
        else:
            results.append({
                "코드": "U-13",
                "진단 결과": "양호",
                "현황": "주요 파일의 권한에 SUID와 SGID 설정이 부여되어 있지 않음",
                "대응방안": "현재 설정 유지",
                "결과": "정상"
            })
    except subprocess.CalledProcessError as e:
        results.append({
            "코드": "U-13",
            "진단 결과": "오류",
            "현황": "SUID/SGID 설정 파일 점검 중 오류 발생",
            "대응방안": "점검 스크립트 오류 확인 및 수정 필요",
            "결과": "오류"
        })

    return results

def save_results_to_json(results, file_path):
    with open(file_path, 'w') as f:
        json.dump(results, f, ensure_ascii=False, indent=4)

def main():
    results = check_suid_sgid_files()
    save_results_to_json(results, "suid_sgid_files_check_result.json")
    print("SUID, SGID, Sticky bit 설정 파일 점검 결과를 suid_sgid_files_check_result.json 파일에 저장하였습니다.")

if __name__ == "__main__":
    main()
