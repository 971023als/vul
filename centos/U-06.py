#!/bin/python3

import os
import subprocess
import json

def check_file_directory_ownership():
    results = []
    base_path = "/root/"
    try:
        # 'find' 명령어를 사용하여 소유자가 없는 파일 및 디렉터리를 찾습니다.
        invalid_owner_files = subprocess.check_output(["find", base_path, "-nouser"], stderr=subprocess.DEVNULL).decode().strip()
        
        if not invalid_owner_files:
            results.append({
                "코드": "U-06",
                "진단 결과": "양호",
                "현황": "소유자가 존재하지 않은 파일 또는 디렉터리를 찾을 수 없습니다.",
                "대응방안": "현재 설정 유지",
                "결과": "정상"
            })
        else:
            results.append({
                "코드": "U-06",
                "진단 결과": "취약",
                "현황": "소유자가 존재하지 않은 파일 또는 디렉터리가 존재함",
                "대응방안": "잘못된 소유자 파일 또는 디렉터리 소유자 수정 권장",
                "결과": "경고",
                "의심 파일": invalid_owner_files.split("\n")
            })

    except subprocess.CalledProcessError as e:
        results.append({
            "코드": "U-06",
            "진단 결과": "오류",
            "현황": "파일 및 디렉터리 소유자 점검 중 오류 발생",
            "대응방안": "시스템 로그 확인 및 문제 해결 필요",
            "결과": "오류"
        })

    return results

def save_results_to_json(results, file_path):
    with open(file_path, 'w') as f:
        json.dump(results, f, ensure_ascii=False, indent=4)

def main():
    results = check_file_directory_ownership()
    save_results_to_json(results, "file_directory_ownership_check_result.json")
    print("파일 및 디렉토리 소유자 설정 점검 결과를 file_directory_ownership_check_result.json 파일에 저장하였습니다.")

if __name__ == "__main__":
    main()
