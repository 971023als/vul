#!/bin/python3

import os
import stat
import json

def check_xinetd_conf_file_ownership_and_permission():
    results = []
    xinetd_conf_file = "/etc/xinetd.conf"
    expected_permission = 0o600  # Octal notation

    if not os.path.isfile(xinetd_conf_file):
        results.append({
            "코드": "U-10",
            "진단 결과": "정보",
            "현황": f"{xinetd_conf_file} 파일이 없습니다.",
            "대응방안": "필요한 경우 {xinetd_conf_file} 파일 생성 및 적절한 권한 설정 권장",
            "결과": "정보"
        })
    else:
        file_stat = os.stat(xinetd_conf_file)
        owner_uid = file_stat.st_uid
        file_permission = stat.S_IMODE(file_stat.st_mode)
        owner_name = os.getpwuid(owner_uid).pw_name

        if owner_name != "root":
            results.append({
                "코드": "U-10",
                "진단 결과": "취약",
                "현황": f"{xinetd_conf_file} 파일의 소유자가 root가 아님",
                "대응방안": f"{xinetd_conf_file} 파일의 소유자를 root로 변경 권장",
                "결과": "경고"
            })

        if file_permission != expected_permission:
            results.append({
                "코드": "U-10",
                "진단 결과": "취약",
                "현황": f"{xinetd_conf_file} 파일의 권한이 {oct(file_permission)}로 설정됨, 600 권장",
                "대응방안": f"{xinetd_conf_file} 파일의 권한을 600으로 설정 권장",
                "결과": "경고"
            })
        else:
            results.append({
                "코드": "U-10",
                "진단 결과": "양호",
                "현황": f"{xinetd_conf_file} 파일의 소유자가 root이며 권한이 600임",
                "대응방안": "현재 설정 유지",
                "결과": "정상"
            })

    return results

def save_results_to_json(results, file_path):
    with open(file_path, 'w') as f:
        json.dump(results, f, ensure_ascii=False, indent=4)

def main():
    results = check_xinetd_conf_file_ownership_and_permission()
    save_results_to_json(results, "xinetd_conf_file_ownership_permission_check_result.json")
    print("'/etc/xinetd.conf' 파일 소유자 및 권한 설정 점검 결과를 xinetd_conf_file_ownership_permission_check_result.json 파일에 저장하였습니다.")

if __name__ == "__main__":
    main()
