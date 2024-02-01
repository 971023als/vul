#!/usr/bin/python3
import subprocess
import json

def check_nfs_services_disabled():
    results = {
        "분류": "서비스 관리",
        "코드": "U-24",
        "위험도": "상",
        "진단 항목": "NFS 서비스 비활성화",
        "진단 결과": "양호",  # Assume "Good" until proven otherwise
        "현황": [],
        "대응방안": "불필요한 NFS 서비스 관련 데몬 비활성화"
    }

    try:
        # Execute the command to check for NFS related processes
        cmd = "ps -ef | grep -iE 'nfs|rpc.statd|statd|rpc.lockd|lockd' | grep -ivE 'grep|kblockd|rstatd|'"
        nfs_processes = subprocess.check_output(cmd, shell=True, text=True)
        
        # If the command output is not empty, NFS services are considered running
        if nfs_processes.strip():
            results["진단 결과"] = "취약"
            results["현황"].append("불필요한 NFS 서비스 관련 데몬이 실행 중입니다.")
    except subprocess.CalledProcessError as e:
        # Handle potential errors during subprocess execution
        results["진단 결과"] = "오류"
        results["현황"].append(f"서비스 확인 중 오류 발생: {e}")

    return results

def main():
    results = check_nfs_services_disabled()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
