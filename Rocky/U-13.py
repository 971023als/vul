#!/usr/bin/python3
import os
import stat
import json

def check_suid_sgid_permissions():
    results = {
        "분류": "파일 및 디렉터리 관리",
        "코드": "U-13",
        "위험도": "상",
        "진단 항목": "SUID, SGID 설정 파일 점검",
        "진단 결과": "양호",  # 초기 상태를 "양호"로 설정
        "현황": [],
        "대응방안": "주요 실행파일의 권한에 SUID와 SGID에 대한 설정이 부여되어 있지 않은 경우"
    }

    executables = [
        "/sbin/dump", "/sbin/restore", "/sbin/unix_chkpwd",
        "/usr/bin/at", "/usr/bin/lpq", "/usr/bin/lpq-lpd",
        "/usr/bin/lpr", "/usr/bin/lpr-lpd", "/usr/bin/lprm",
        "/usr/bin/lprm-lpd", "/usr/bin/newgrp", "/usr/sbin/lpc",
        "/usr/sbin/lpc-lpd", "/usr/sbin/traceroute"
    ]

    vulnerable_files = []

    for executable in executables:
        if os.path.isfile(executable):
            mode = os.stat(executable).st_mode
            if mode & (stat.S_ISUID | stat.S_ISGID):
                vulnerable_files.append(executable)

    if vulnerable_files:
        results["진단 결과"] = "취약"
        results["현황"] = vulnerable_files
    else:
        # "현황" 필드에 "양호" 상태에 대한 설명 추가
        results["현황"].append("SUID나 SGID에 대한 설정이 부여된 주요 실행 파일이 없습니다.")

    return results

def main():
    results = check_suid_sgid_permissions()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
