#!/usr/bin/python3
import re
import json

def check_root_remote_access_restriction():
    results = {
        "분류": "시스템 설정",
        "코드": "U-01",
        "위험도": "상",
        "진단 항목": "root 계정 원격 접속 제한",
        "진단 결과": "",
        "현황": [],
        "대응방안": "[양호]: 원격 서비스를 사용하지 않거나 사용 시 직접 접속을 차단한 경우\n[취약]: root 직접 접속을 허용하고 원격 서비스를 사용하는 경우"
    }

    ssh_config_file = "/etc/ssh/sshd_config"
    try:
        with open(ssh_config_file, 'r') as file:
            content = file.read()
            if re.search(r'^PermitRootLogin yes', content, re.MULTILINE):
                results["진단 결과"] = "취약"
                results["현황"].append("원격 터미널 서비스를 통해 루트 직접 액세스가 허용됨")
            else:
                results["진단 결과"] = "양호"
                results["현황"].append("원격 터미널 서비스를 통해 루트 직접 액세스가 허용되지 않음")
    except FileNotFoundError:
        results["진단 결과"] = "정보부족"
        results["현황"].append(f"{ssh_config_file} 파일이 존재하지 않습니다.")

    return results

def main():
    results = check_root_remote_access_restriction()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
