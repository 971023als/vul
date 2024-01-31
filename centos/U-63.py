#!/bin/python3

import os
import stat
import json
import pwd

def check_ftpusers_file():
    results = []
    ftpusers_file = "/etc/vsftpd/ftpusers"

    # ftpusers 파일 확인
    if not os.path.isfile(ftpusers_file):
        result = {
            "분류": "네트워크 서비스",
            "코드": "U-63",
            "위험도": "정보",
            "진단 항목": "ftpusers 파일 소유자 및 권한 설정",
            "진단 결과": "정보",
            "현황": "ftpusers 파일이 없습니다. 확인해주세요.",
            "대응방안": "ftpusers 파일 생성 및 설정 권장",
            "결과": "정보"
        }
        print("INFO: ftpusers 파일이 없습니다. 확인해주세요.")
    else:
        file_stat = os.stat(ftpusers_file)
        owner = pwd.getpwuid(file_stat.st_uid).pw_name
        permissions = oct(file_stat.st_mode)[-3:]

        # ftpusers 파일 소유자 root 확인
        if owner == "root":
            owner_result = "OK: root가 ftpusers 파일을 소유하고 있습니다."
            owner_status = "양호"
        else:
            owner_result = "경고: root가 ftpusers 파일을 소유하고 있지 않습니다."
            owner_status = "취약"

        # ftpusers 파일 권한 확인
        if int(permissions, 8) <= 640:
            perm_result = "OK: 권한이 640 이하입니다."
            perm_status = "양호"
        else:
            perm_result = "경고: 권한이 640 초과입니다."
            perm_status = "취약"

        result = {
            "분류": "네트워크 서비스",
            "코드": "U-63",
            "위험도": "높음" if owner_status == "취약" or perm_status == "취약" else "낮음",
            "진단 항목": "ftpusers 파일 소유자 및 권한 설정",
            "진단 결과": f"{owner_status}, {perm_status}",
            "현황": f"{owner_result} {perm_result}",
            "대응방안": "소유자를 root로 설정 및 권한을 640 이하로 설정 권장",
            "결과": "경고" if owner_status == "취약" or perm_status == "취약" else "정상"
        }
        print(f"{owner_result} {perm_result}")

    results.append(result)
    return results

def save_results_to_json(results, file_path):
    with open(file_path, 'w') as f:
        json.dump(results, f, ensure_ascii=False, indent=4)

def main():
    results = check_ftpusers_file()
    save_results_to_json(results, "ftpusers_check_result.json")
    print("ftpusers 파일 소유자 및 권한 설정 점검 결과를 ftpusers_check_result.json 파일에 저장하였습니다.")

if __name__ == "__main__":
    main()
