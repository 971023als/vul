#!/usr/bin/python3
import subprocess
import json

def check_automountd_disabled():
    results = {
        "분류": "서비스 관리",
        "코드": "U-26",
        "위험도": "상",
        "진단 항목": "automountd 제거",
        "진단 결과": None,  # 초기 상태 설정, 검사 후 결과에 따라 업데이트
        "현황": [],
        "대응방안": "automountd 서비스 비활성화"
    }

    try:
        # automountd 또는 autofs 서비스 실행 여부 확인
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

    # 진단 결과가 명시적으로 설정되지 않은 경우 기본값을 "양호"로 설정
    if results["진단 결과"] is None:
        results["진단 결과"] = "양호"
        results["현황"].append("automountd 서비스 관련 문제가 발견되지 않았습니다.")

    return results

def main():
    results = check_automountd_disabled()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
