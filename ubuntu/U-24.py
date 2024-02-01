#!/usr/bin/python3
import subprocess
import json

def check_nfs_services_status():
    results = {
        "분류": "시스템 관리",
        "코드": "U-24",
        "위험도": "상",
        "진단 항목": "NFS 서비스 비활성화",
        "진단 결과": "",
        "현황": [],
        "대응방안": "[양호]: 불필요한 NFS 서비스가 비활성화 되어있는 경우\n[취약]: 불필요한 NFS 서비스가 활성화 되어있는 경우"
    }

    try:
        nfs_services = subprocess.check_output("ps -ef | egrep 'nfsd|statd|lockd' | grep -v grep", shell=True, text=True)
        if nfs_services.strip():
            results["진단 결과"] = "취약"
            results["현황"].append("NFS 서비스 데몬이 실행 중입니다.")
        else:
            results["진단 결과"] = "양호"
            results["현황"].append("NFS 서비스 데몬이 실행되고 있지 않습니다.")
    except subprocess.CalledProcessError as e:
        results["현황"].append("NFS 관련 파일이 없거나 확인 중 오류가 발생했습니다.")

    return results

def main():
    results = check_nfs_services_status()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
