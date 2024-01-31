#!/usr/bin/python3

import os
import json

# 결과 저장을 위한 딕셔너리
results = {
    "분류": "시스템 보안",
    "코드": "U-04",
    "위험도": "상",
    "진단 항목": "패스워드 파일 보호",
    "진단 결과": "",
    "현황": [],
    "대응방안": "쉐도우 패스워드 사용 및 패스워드 암호화 적용 권장."
}

# /etc/shadow 파일 존재 여부 확인
shadow_file = "/etc/shadow"
if os.path.exists(shadow_file):
    results["현황"].append(f"{shadow_file} 파일이 존재합니다.")
    # /etc/passwd 파일에서 패스워드 필드 확인
    passwd_file = "/etc/passwd"
    with open(passwd_file, 'r') as f:
        for line in f:
            parts = line.split(":")
            if parts[1] != 'x':
                results["진단 결과"] = "취약"
                results["현황"].append("쉐도우 패스워드를 사용하지 않고, 패스워드를 암호화하여 저장하지 않는 경우")
                break
        else:  # 모든 계정이 'x'로 설정된 경우
            results["진단 결과"] = "양호"
            results["현황"].append("쉐도우 패스워드를 사용하거나, 패스워드를 암호화하여 저장하는 경우")
else:
    results["진단 결과"] = "정보 부족"
    results["현황"].append(f"{shadow_file} 파일이 존재하지 않습니다.")

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
