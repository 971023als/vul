#!/usr/bin/python3
import os
import stat
import json

def check_suid_sgid_files():
    results = {
        "분류": "시스템 설정",
        "코드": "U-13",
        "위험도": "상",
        "진단 항목": "SUID, SGID 설정 파일 점검",
        "진단 결과": "",
        "현황": [],
        "대응방안": "[양호]: 주요 파일의 권한에 SUID와 SGID에 대한 설정이 부여되어 있지 않은 경우\n[취약]: 주요 파일의 권한에 SUID와 SGID에 대한 설정이 부여되어 있는 경우"
    }

    # 전체 시스템에서 SUID와 SGID가 설정된 파일 탐색
    for root, dirs, files in os.walk("/"):
        for file in files:
            file_path = os.path.join(root, file)
            try:
                file_stat = os.stat(file_path)
                if file_stat.st_mode & (stat.S_ISUID | stat.S_ISGID):
                    owner = stat.filemode(file_stat.st_mode)
                    if os.getuid() == file_stat.st_uid:
                        results["현황"].append(f"SUID/SGID 설정이 부여된 파일: {file_path} (소유자: root)")
                    else:
                        results["진단 결과"] = "취약"
                        results["현황"].append(f"SUID/SGID 설정이 부여된 파일: {file_path} (소유자: {owner})")
            except FileNotFoundError:
                continue

    if not results["현황"]:
        results["진단 결과"] = "양호"
        results["현황"].append("SUID와 SGID 설정이 부여된 주요 파일이 존재하지 않습니다.")

    return results

def main():
    results = check_suid_sgid_files()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
