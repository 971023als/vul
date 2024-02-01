#!/usr/bin/python3

import subprocess
import json

def check_finger_service_status():
    results = {
        "분류": "서비스 관리",
        "코드": "U-19",
        "위험도": "상",
        "진단 항목": "finger 서비스 비활성화",
        "진단 결과": "",
        "현황": "",
        "대응방안": "Finger 서비스를 비활성화 권장."
    }

    try:
        # Check if the finger service is running by trying to find its process
        process = subprocess.run(['pgrep', '-x', 'fingerd'], check=False, capture_output=True, text=True)
        if process.stdout:
            results["진단 결과"] = "취약"
            results["현황"] = "Finger 서비스가 실행되고 있습니다."
        else:
            results["진단 결과"] = "양호"
            results["현황"] = "Finger 서비스가 실행되고 있지 않습니다."
    except Exception as e:
        results["진단 결과"] = "확인 불가"
        results["현황"] = str(e)

    return results

def main():
    results = check_finger_service_status()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
