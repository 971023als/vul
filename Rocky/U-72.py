#!/usr/bin/python3
import json

def check_system_logging_policy():
    results = {
        "분류": "시스템 설정",
        "코드": "U-72",
        "위험도": "상",
        "진단 항목": "정책에 따른 시스템 로깅 설정",
        "진단 결과": "",
        "현황": [],
        "대응방안": "[양호]: 로그 기록 정책이 정책에 따라 설정되어 수립되어 있는 경우\n[취약]: 로그 기록 정책이 정책에 따라 설정되어 수립되어 있지 않은 경우"
    }

    filename = "/etc/rsyslog.conf"
    expected_content = [
        "*.info;mail.none;authpriv.none;cron.none /var/log/messages",
        "authpriv.* /var/log/secure",
        "mail.* /var/log/maillog",
        "cron.* /var/log/cron",
        "*.alert /dev/console",
        "*.emerg *"
    ]

    try:
        with open(filename, 'r') as file:
            content = file.read()
            match_count = sum(1 for line in expected_content if line in content)
            
            if match_count == len(expected_content):
                results["진단 결과"] = "양호"
                results["현황"].append(f"{filename}의 내용이 정확합니다.")
            else:
                results["진단 결과"] = "취약"
                results["현황"].append(f"{filename}의 내용이 잘못되었습니다.")
    except FileNotFoundError:
        results["진단 결과"] = "취약"
        results["현황"].append(f"{filename} 파일이 존재하지 않습니다.")

    return results

def main():
    results = check_system_logging_policy()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()