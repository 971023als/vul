#!/usr/bin/python3
import json

def check_access_control_settings():
    results = {
        "분류": "시스템 설정",
        "코드": "U-18",
        "위험도": "상",
        "진단 항목": "접속 IP 및 포트 제한",
        "진단 결과": "",
        "현황": [],
        "대응방안": "[양호]: /etc/hosts.deny 파일에 ALL Deny 설정 후 /etc/hosts.allow 파일에 접근을 허용할 특정 호스트를 등록한 경우\n[취약]: 위와 같이 설정되지 않은 경우"
    }

    try:
        with open('/etc/hosts.allow', 'r') as f:
            allow_rules = f.read().strip()
        with open('/etc/hosts.deny', 'r') as f:
            deny_rules = f.read().strip()

        if allow_rules and deny_rules:
            results["진단 결과"] = "양호"
            results["현황"].append("접속을 허용할 특정 호스트에 대한 IP 주소 및 포트 제한을 설정한 경우")
        else:
            results["진단 결과"] = "취약"
            results["현황"].append("접속을 허용할 특정 호스트에 대한 IP 주소 및 포트 제한을 설정하지 않은 경우")

    except FileNotFoundError as e:
        results["진단 결과"] = "취약"
        results["현황"].append(str(e))

    return results

def main():
    results = check_access_control_settings()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
