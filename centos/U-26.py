#!/usr/bin/python3
import subprocess
import json

def check_automountd_disabled():
    results = {
        "분류": "서비스 관리",
        "코드": "U-26",
        "위험도": "상",
        "진단 항목": "automountd 제거",
        "진단 결과": "양호",  # Assume "Good" until proven otherwise
        "현황": [],
        "대응방안": "automountd 서비스 비활성화"
    }

    try:
        # Check for the automountd or autofs service
        automountd_running = subprocess.check_output(
            "ps -ef | grep -iE 'automount|autofs' | grep -v 'grep'", 
            shell=True, text=True
        ).strip()

        if automountd_running:
            results["진단 결과"] = "취약"
            results["현황"].append("automountd 서비스가 실행 중입니다.")
        else:
            results["진단 결과"] = "양호"
            results["현황"].append("automountd 서비스가 비활성화되어 있습니다.")

    except subprocess.CalledProcessError as e:
        results["진단 결과"] = "오류"
        results["현황"].append(f"automountd 서비스 확인 중 오류 발생: {e}")

    return results

def main():
    results = check_automountd_disabled()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
