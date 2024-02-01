#!/usr/bin/python3
import subprocess
import json

def check_automountd_service_status():
    results = {
        "분류": "시스템 설정",
        "코드": "U-26",
        "위험도": "상",
        "진단 항목": "automountd 제거 '확인 필요'",
        "진단 결과": "",
        "현황": [],
        "대응방안": "[양호]: automountd 서비스가 비활성화 되어있는 경우\n[취약]: automountd 서비스가 활성화 되어있는 경우"
    }

    try:
        # Execute the command to check for automount process
        process = subprocess.run(['ps', '-ef'], capture_output=True, text=True, check=True)
        output = process.stdout

        # Check if automount process is running
        if 'automount' in output:
            results["진단 결과"] = "취약"
            results["현황"].append("Automount 서비스가 실행 중입니다.")
        else:
            results["진단 결과"] = "양호"
            results["현황"].append("Automount 서비스가 실행되고 있지 않습니다.")
    except subprocess.CalledProcessError as e:
        results["현황"].append(f"Automount 서비스 상태 확인 중 오류 발생: {e}")

    return results

def main():
    results = check_automountd_service_status()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
