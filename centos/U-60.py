#!/bin/python3

import subprocess
import json

def check_ssh_installed():
    try:
        # SSH 바이너리의 위치를 확인합니다.
        subprocess.check_output(['which', 'ssh'], stderr=subprocess.STDOUT)
        return True
    except subprocess.CalledProcessError:
        return False

def evaluate_ssh_use():
    results = []
    if check_ssh_installed():
        result = {
            "분류": "시스템 설정",
            "코드": "U-60",
            "위험도": "낮음",
            "진단 항목": "SSH 원격접속 허용",
            "진단 결과": "양호",
            "현황": "SSH가 설치되었습니다.",
            "대응방안": "SSH 사용 유지",
            "결과": "정상"
        }
        print("OK: SSH가 설치되었습니다.")
    else:
        result = {
            "분류": "시스템 설정",
            "코드": "U-60",
            "위험도": "높음",
            "진단 항목": "SSH 원격접속 허용",
            "진단 결과": "취약",
            "현황": "SSH가 설치되지 않았습니다.",
            "대응방안": "SSH 설치 및 사용 권장",
            "결과": "경고"
        }
        print("경고: SSH가 설치되지 않았습니다.")
    results.append(result)
    return results

def save_results_to_json(results, file_path):
    with open(file_path, 'w') as f:
        json.dump(results, f, ensure_ascii=False, indent=4)

def main():
    results = evaluate_ssh_use()
    save_results_to_json(results, "ssh_check_result.json")
    print("\nSSH 점검 결과를 ssh_check_result.json 파일에 저장하였습니다.")

if __name__ == "__main__":
    main()
