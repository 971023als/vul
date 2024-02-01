#!/usr/bin/python3
import subprocess
import json

def check_nis_services_status():
    results = {
        "분류": "서비스 관리",
        "코드": "U-28",
        "위험도": "상",
        "진단 항목": "NIS, NIS+ 점검",
        "진단 결과": "양호",  # Assume "Good" until proven otherwise
        "현황": [],
        "대응방안": "NIS 서비스 비활성화 혹은 필요 시 NIS+ 사용"
    }

    try:
        # Command to check for NIS related processes
        nis_processes = subprocess.check_output(
            "ps -ef | grep -iE 'ypserv|ypbind|ypxfrd|rpc.yppasswdd|rpc.ypupdated' | grep -v 'grep'", 
            shell=True, text=True
        ).strip()

        if nis_processes:
            results["진단 결과"] = "취약"
            results["현황"].append("NIS 서비스가 실행 중입니다.")
        else:
            results["진단 결과"] = "양호"
            results["현황"].append("NIS 서비스가 비활성화되어 있습니다.")

    except subprocess.CalledProcessError as e:
        results["진단 결과"] = "오류"
        results["현황"].append(f"NIS 서비스 확인 중 오류 발생: {e}")

    return results

def main():
    results = check_nis_services_status()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
