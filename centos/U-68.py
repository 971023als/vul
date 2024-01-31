#!/bin/python3

import os
import json

def check_logon_messages():
    results = []
    files = ["/etc/motd", "/etc/issue.net", "/etc/vsftpd/vsftpd.conf", "/etc/mail/sendmail.cf", "/etc/named.conf"]

    for file_path in files:
        if not os.path.exists(file_path):
            result = {
                "분류": "시스템 설정",
                "코드": "U-68",
                "위험도": "정보",
                "진단 항목": "로그온 시 경고 메시지 제공",
                "진단 결과": "정보",
                "현황": f"{file_path}이(가) 존재하지 않습니다.",
                "대응방안": f"{file_path}에 로그온 메시지 설정 권장",
                "결과": "정보"
            }
        else:
            result = {
                "분류": "시스템 설정",
                "코드": "U-68",
                "위험도": "낮음",
                "진단 항목": "로그온 시 경고 메시지 제공",
                "진단 결과": "양호",
                "현황": f"{file_path}이(가) 존재합니다.",
                "대응방안": "현재 설정 유지",
                "결과": "정상"
            }
        results.append(result)

    # 전체 점검 결과가 "정보"만 있는 경우, 전체적으로 "취약"으로 판단할 수 있음
    if all(r["결과"] == "정보" for r in results):
        for r in results:
            r["위험도"] = "높음"
            r["진단 결과"] = "취약"
            r["결과"] = "경고"

    return results

def save_results_to_json(results, file_path):
    with open(file_path, 'w') as f:
        json.dump(results, f, ensure_ascii=False, indent=4)

def main():
    results = check_logon_messages()
    save_results_to_json(results, "logon_message_check_result.json")
    print("로그온 시 경고 메시지 제공 여부 점검 결과를 logon_message_check_result.json 파일에 저장하였습니다.")

if __name__ == "__main__":
    main()
