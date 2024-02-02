#!/usr/bin/python3
import subprocess
import json

def check_nfs_services_disabled():
    results = {
        "분류": "서비스 관리",
        "코드": "U-24",
        "위험도": "상",
        "진단 항목": "NFS 서비스 비활성화",
        "진단 결과": None,  # 초기 상태 설정, 검사 후 결과에 따라 업데이트
        "현황": [],
        "대응방안": "불필요한 NFS 서비스 관련 데몬 비활성화"
    }

    try:
        # NFS 관련 프로세스 확인을 위한 명령어 실행
        cmd = "ps -ef | grep -iE 'nfs|rpc.statd|statd|rpc.lockd|lockd' | grep -ivE 'grep|kblockd|rstatd|'"
        nfs_processes = subprocess.check_output(cmd, shell=True, text=True)
        
        # 명령어 실행 결과가 비어 있지 않다면 NFS 서비스가 실행 중으로 간주
        if nfs_processes.strip():
            results["진단 결과"] = "취약"
            results["현황"].append("불필요한 NFS 서비스 관련 데몬이 실행 중입니다.")
        else:
            results["진단 결과"] = "양호"
            results["현황"].append("NFS 서비스 관련 데몬이 비활성화되어 있습니다.")
    except subprocess.CalledProcessError as e:
        # subprocess 실행 중 오류 처리
        results["진단 결과"] = "오류"
        results["현황"].append(f"서비스 확인 중 오류 발생: {e}")

    return results

def main():
    results = check_nfs_services_disabled()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
