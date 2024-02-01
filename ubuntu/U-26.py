#!/usr/bin/python3
import subprocess
import json

def check_automountd_service_status():
    results = {
        "분류": "시스템 관리",
        "코드": "U-26",
        "위험도": "상",
        "진단 항목": "automountd 제거",
        "진단 결과": "",
        "현황": [],
        "대응방안": "[양호]: automountd 서비스가 비활성화 되어있는 경우\n[취약]: automountd 서비스가 활성화 되어있는 경우"
    }

    try:
        # `automount` 프로세스 확인
        process_output = subprocess.check_output("ps -ef | grep automount | grep -v grep", shell=True, text=True)
        if process_output.strip():
            results["진단 결과"] = "취약"
            results["현황"].append("Automount 서비스가 실행 중입니다.")
        else:
            results["진단 결과"] = "양호"
            results["현황"].append("Automount 서비스가 실행되고 있지 않습니다.")
    except subprocess.CalledProcessError:
        # `ps` 명령어 실행 실패 시
        results["현황"].append("Automount 서비스 확인 중 에러 발생")
    except Exception as e:
        results["현황"].append(f"예외 발생: {str(e)}")

    return results

def main():
    results = check_automountd_service_status()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
