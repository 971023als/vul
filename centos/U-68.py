#!/bin/python3

import os
import json

# 로그온 메시지를 확인할 파일 목록
files = ["/etc/motd", "/etc/issue.net", "/etc/vsftpd/vsftpd.conf", "/etc/mail/sendmail.cf", "/etc/named.conf"]

# 결과 저장을 위한 딕셔너리
results = {
    "분류": "서비스 관리",
    "코드": "U-68",
    "위험도": "상",
    "진단 항목": "로그온 시 경고 메시지 제공",
    "진단 결과": "양호",
    "현황": [],
    "대응방안": "로그온 시 경고 메시지가 설정되어 있지 않은 서비스에 대해 해당 설정을 적용하세요."
}

# 각 파일의 존재 여부와 내용 확인
for file_path in files:
    if not os.path.exists(file_path):
        results["현황"].append(f"{file_path} 파일이 존재하지 않습니다.")
        if results["진단 결과"] != "취약":  # 최소 한 번이라도 취약 판정이 나면 취약 유지
            results["진단 결과"] = "취약"
    else:
        results["현황"].append(f"{file_path} 파일이 존재합니다.")
        with open(file_path, 'r') as file:
            contents = file.read().strip()
            if len(contents) == 0:
                results["현황"].append(f"{file_path} 파일이 비어 있습니다.")
                results["진단 결과"] = "취약"

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
