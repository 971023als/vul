#!/usr/bin/python3
import subprocess
import json

def check_nis_services_status():
    results = {
        "분류": "시스템 관리",
        "코드": "U-28",
        "위험도": "상",
        "진단 항목": "NIS, NIS+ 점검",
        "진단 결과": "",
        "현황": [],
        "대응방안": "[양호]: NIS 서비스가 비활성화 되어 있거나, 필요 시 NIS+를 사용하는 경우\n[취약]: NIS 서비스가 활성화 되어 있는 경우"
    }

    try:
        process_output = subprocess.check_output("ps -ef | egrep 'ypserv|ypbind|ypxfrd|rpc.yppasswdd|rpc.ypupdated' | grep -v grep", shell=True, text=True)
        if process_output.strip():
            for line in process_output.strip().split('\n'):
                pid, process = line.split()[:2]
                results["현황"].append(f"{pid} / {process}가 실행 중입니다.")
            results["진단 결과"] = "취약"
        else:
            results["현황"].append("NIS 서비스가 비활성화되었습니다.")
            results["진단 결과"] = "양호"
    except subprocess.CalledProcessError:
        results["현황"].append("NIS 서비스 확인 중 에러 발생")
    except Exception as e:
        results["현황"].append(f"예외 발생: {str(e)}")

    return results

def main():
    results = check_nis_services_status()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
