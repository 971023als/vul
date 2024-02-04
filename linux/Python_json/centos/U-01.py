#!/usr/bin/python3
import json
import subprocess
import re

def check_remote_root_access_restriction():
    results = {
        "분류": "계정관리",
        "코드": "U-01",
        "위험도": "상",
        "진단 항목": "root 계정 원격접속 제한",
        "진단 결과": "",
        "현황": [],
        "대응방안": "원격 터미널 서비스 사용 시 root 직접 접속을 차단"
    }

    # Telnet 서비스 검사
    try:
        telnet_status = subprocess.run(["grep", "-vE", "^#|^\\s#", "/etc/services"], capture_output=True, text=True)
        telnet_ports = re.findall(r'telnet\s+(\d+)/tcp', telnet_status.stdout, re.I)
        if telnet_ports:
            results["현황"].append("Telnet 서비스 포트가 활성화되어 있습니다.")
            results["진단 결과"] = "취약"
    except Exception as e:
        results["현황"].append(f"Telnet 서비스 검사 중 오류 발생: {e}")

    # SSH 서비스 검사
    sshd_configs = subprocess.getoutput("find / -name 'sshd_config' -type f 2>/dev/null").splitlines()
    permit_root_login = False
    for sshd_config in sshd_configs:
        try:
            with open(sshd_config, 'r') as file:
                for line in file:
                    if re.match(r'^PermitRootLogin\s+no', line, re.I):
                        permit_root_login = True
                        break
        except Exception as e:
            results["현황"].append(f"{sshd_config} 파일 읽기 중 오류 발생: {e}")

    if not permit_root_login and sshd_configs:
        results["현황"].append("SSH 서비스에서 root 계정의 원격 접속이 허용되고 있습니다.")
        results["진단 결과"] = "취약"
    elif sshd_configs:
        results["현황"].append("SSH 서비스에서 root 계정의 원격 접속이 제한되어 있습니다.")
        results["진단 결과"] = "양호"

    return results

def main():
    results = check_remote_root_access_restriction()
    # 결과를 JSON 형식으로 출력합니다.
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
