#!/usr/bin/python3
import subprocess
import json

def check_ssh_installation():
    results = {
        "분류": "시스템 설정",
        "코드": "U-60",
        "위험도": "상",
        "진단 항목": "ssh 원격접속 허용",
        "진단 결과": "",
        "현황": [],
        "대응방안": "[양호]: 원격 접속 시 SSH 프로토콜을 사용하는 경우\n[취약]: 원격 접속 시 Telnet, FTP 등 안전하지 않은 프로토콜을 사용하는 경우"
    }

    try:
        subprocess.check_call(["which", "ssh"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        results["진단 결과"] = "양호"
        results["현황"].append("SSH가 설치되었습니다.")
    except subprocess.CalledProcessError:
        results["진단 결과"] = "취약"
        results["현황"].append("SSH가 설치되지 않았습니다.")

    return results

def main():
    results = check_ssh_installation()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
