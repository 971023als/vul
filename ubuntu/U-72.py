#!/usr/bin/env python3
import json
import re

# 결과를 저장할 딕셔너리
results = {
    "U-72": {
        "title": "정책에 따른 시스템 로깅 설정",
        "status": "",
        "description": {
            "good": "로그 기록 정책이 정책에 따라 설정되어 수립되어 있는 경우",
            "bad": "로그 기록 정책이 정책에 따라 설정되어 수립되어 있지 않은 경우"
        },
        "details": []
    }
}

def check_rsyslog_config():
    filename = "/etc/rsyslog.conf"
    
    try:
        with open(filename, 'r') as file:
            config_content = file.read()
        
        expected_content = [
            "*.info;mail.none;authpriv.none;cron.none /var/log/messages",
            "authpriv.* /var/log/secure",
            "mail.* /var/log/maillog",
            "cron.* /var/log/cron",
            "*.alert /dev/console",
            "*.emerg *"
        ]
        
        match_count = 0
        for content in expected_content:
            if re.search(re.escape(content), config_content):
                match_count += 1
        
        if match_count == len(expected_content):
            results["U-72"]["status"] = "양호"
            results["U-72"]["details"].append(f"{filename}의 내용이 정책에 따라 적절히 설정되어 있습니다.")
        else:
            results["U-72"]["status"] = "취약"
            results["U-72"]["details"].append(f"{filename}의 내용이 일부 누락되었거나 정책에 맞지 않습니다.")
    except FileNotFoundError:
        results["U-72"]["status"] = "취약"
        results["U-72"]["details"].append(f"{filename} 가 존재하지 않습니다.")

check_rsyslog_config()

# 결과 파일에 JSON 형태로 저장
result_file = 'rsyslog_policy_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
