#!/usr/bin/python3

import os
import subprocess
import json

def check_world_writable_files():
    results = {
        "분류": "시스템 파일 설정",
        "코드": "U-15",
        "위험도": "상",
        "진단 항목": "world writable 파일 점검",
        "진단 결과": "",
        "현황": [],
        "대응방안": "world writable 파일의 존재 이유를 확인하고 필요 없는 경우 권한 수정 권장."
    }

    # 전체 시스템에서 world writable 파일 검색
    cmd = "find / -type f -perm -o=w ! -path '/proc/*' ! -path '/sys/*' -exec ls -ld {} \;"
    process = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    stdout, stderr = process.communicate()

    if stdout:
        world_writable_files = stdout.strip().split('\n')
        results["현황"].extend(world_writable_files)
        results["진단 결과"] = "취약"
    else:
        results["현황"].append("world writable 파일이 없습니다.")
        results["진단 결과"] = "양호"

    return results

def main():
    results = check_world_writable_files()
    # 결과를 JSON 형태로 출력
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
