#!/usr/bin/python3
import subprocess
import json

def check_finger_service_status():
    results = {
        "분류": "시스템 설정",
        "코드": "U-19",
        "위험도": "상",
        "진단 항목": "finger 서비스 비활성화",
        "진단 결과": "",
        "현황": [],
        "대응방안": "[양호]: Finger 서비스가 비활성화 되어 있는 경우\n[취약]: Finger 서비스가 활성화 되어 있는 경우"
    }

    try:
        process = subprocess.run(['pgrep', '-x', 'fingerd'], check=False, capture_output=True, text=True)
        if process.returncode == 0:
            results["진단 결과"] = "취약"
            results["현황"].append("Finger 서비스가 실행되고 있습니다.")
        else:
            results["진단 결과"] = "양호"
            results["현황"].append("Finger 서비스가 실행되고 있지 않습니다.")
    except Exception as e:
        results["현황"].append(f"Finger 서비스 상태 확인 중 오류 발생: {str(e)}")

    return results

def main():
    results = check_finger_service_status()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
