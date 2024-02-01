#!/usr/bin/python3
import datetime
import json

def check_security_patches_applied():
    results = {
        "분류": "시스템 관리",
        "코드": "U-42",
        "위험도": "상",
        "진단 항목": "최신 보안패치 및 벤더 권고사항 적용",
        "진단 결과": "",
        "현황": [],
        "대응방안": "패치 적용 정책을 수립하여 주기적으로 패치를 관리하고 있는 경우"
    }

    patch_log_file = "/var/log/patch.log"
    current_date = datetime.datetime.now().strftime('%Y-%m-%d')
    expected_log_entry = f"Patches installed on {current_date}"

    try:
        with open(patch_log_file, 'r') as file:
            if expected_log_entry in file.read():
                results["진단 결과"] = "양호"
                results["현황"].append(f"'{current_date}'에 설치된 패치 행이 '{patch_log_file}'에 있습니다.")
            else:
                results["진단 결과"] = "취약"
                results["현황"].append(f"'{current_date}'에 설치된 패치 행이 '{patch_log_file}'에 없습니다.")
    except FileNotFoundError:
        results["진단 결과"] = "취약"
        results["현황"].append(f"'{patch_log_file}' 파일을 찾을 수 없습니다.")

    return results

def main():
    results = check_security_patches_applied()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
