#!/bin/python3

import os
import stat
import json

def check_rsyslog_conf_file_ownership_and_permission():
    results = []
    rsyslog_conf_file = "/etc/rsyslog.conf"
    expected_owners = ['root', 'bin', 'sys']
    expected_permission = 0o640  # Octal notation

    if not os.path.exists(rsyslog_conf_file):
        results.append({
            "코드": "U-11",
            "진단 결과": "정보",
            "현황": f"{rsyslog_conf_file} 파일이 존재하지 않습니다.",
            "대응방안": "필요한 경우 {rsyslog_conf_file} 파일 생성 및 적절한 권한 설정 권장",
            "결과": "정보"
        })
    else:
        file_stat = os.stat(rsyslog_conf_file)
        owner_uid = file_stat.st_uid
        file_permission = stat.S_IMODE(file_stat.st_mode)
        owner_name = os.getpwuid(owner_uid).pw_name

        if owner_name not in expected_owners:
            results.append({
                "코드": "U-11",
                "진단 결과": "취약",
                "현황": f"{rsyslog_conf_file} 파일의 소유자가 {owner_name}임, root/bin/sys 중 하나여야 함",
                "대응방안": f"{rsyslog_conf_file} 파일의 소유자를 root/bin/sys 중 하나로 변경 권장",
                "결과": "경고"
            })

        if file_permission > expected_permission:
            results.append({
                "코드": "U-11",
                "진단 결과": "취약",
                "현황": f"{rsyslog_conf_file} 파일의 권한이 {oct(file_permission)}로 설정됨, 640 이하 권장",
                "대응방안": f"{rsyslog_conf_file} 파일의 권한을 640 이하로 설정 권장",
                "결과": "경고"
            })
        else:
            results.append({
                "코드": "U-11",
                "진단 결과": "양호",
                "현황": f"{rsyslog_conf_file} 파일의 소유자 및 권한 설정이 적절함",
                "대응방안": "현재 설정 유지",
                "결과": "정상"
            })

    return results

def save_results_to_json(results, file_path):
    with open(file_path, 'w') as f:
        json.dump(results, f, ensure_ascii=False, indent=4)

def main():
    results = check_rsyslog_conf_file_ownership_and_permission()
    save_results_to_json(results, "rsyslog_conf_file_ownership_permission_check_result.json")
    print("'/etc/rsyslog.conf' 파일 소유자 및 권한 설정 점검 결과를 rsyslog_conf_file_ownership_permission_check_result.json 파일에 저장하였습니다.")

if __name__ == "__main__":
    main()
