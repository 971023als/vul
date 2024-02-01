#!/usr/bin/python3

import os
import subprocess
import json

def check_suid_sgid_files():
    results = {
        "분류": "시스템 설정",
        "코드": "U-13",
        "위험도": "상",
        "진단 항목": "SUID, SGID, Sticky bit 설정 파일 점검",
        "진단 결과": "",
        "현황": [],
        "대응방안": "주요 파일의 권한에서 SUID와 SGID 설정을 제거하세요."
    }

    # 주요 파일에서 SUID와 SGID 비트가 설정된 파일 찾기
    command = "find / -type f \( -perm -4000 -o -perm -2000 \) -exec ls -l {} \;"
    try:
        output = subprocess.check_output(command, shell=True, text=True, stderr=subprocess.STDOUT)
        if output:
            results["현황"].append("SUID 또는 SGID 비트가 설정된 파일이 탐지됨:")
            for line in output.strip().split('\n'):
                results["현황"].append(line)
            results["진단 결과"] = "취약"
        else:
            results["진단 결과"] = "양호"
            results["현황"].append("SUID 또는 SGID 비트가 설정된 주요 파일 없음.")
    except subprocess.CalledProcessError as e:
        results["진단 결과"] = "실행 오류"
        results["현황"].append(f"오류 발생: {e}")

    return results

def main():
    result = check_suid_sgid_files()
    print(json.dumps(result, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
