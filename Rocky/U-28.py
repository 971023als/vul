#!/usr/bin/python3
import subprocess
import json

def check_nis_services_status():
    results = {
        "분류": "시스템 설정",
        "코드": "U-28",
        "위험도": "상",
        "진단 항목": "NIS, NIS+ 점검",
        "진단 결과": "",
        "현황": [],
        "대응방안": "[양호]: NIS 서비스가 비활성화 되어 있거나, 필요 시 NIS+를 사용하는 경우\n[취약]: NIS 서비스가 활성화 되어 있는 경우"
    }

    try:
        # Execute the command to check for NIS processes
        process = subprocess.run(['ps', '-ef'], capture_output=True, text=True, check=True)
        output = process.stdout

        # Check for NIS related processes
        nis_processes = ['ypserv', 'ypbind', 'ypxfrd', 'rpc.yppasswdd', 'rpc.ypupdated']
        active_services = []
        for proc in nis_processes:
            if proc in output:
                active_services.append(proc)

        if active_services:
            results["진단 결과"] = "취약"
            results["현황"].append(f"NIS 서비스가 실행 중입니다: {', '.join(active_services)}")
        else:
            results["진단 결과"] = "양호"
            results["현황"].append("NIS 서비스가 비활성화되었습니다.")

    except subprocess.CalledProcessError as e:
        results["현황"].append(f"NIS 서비스 상태 확인 중 오류 발생: {e}")

    return results

def main():
    results = check_nis_services_status()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
