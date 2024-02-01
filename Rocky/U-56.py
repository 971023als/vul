#!/usr/bin/python3
import re
import json

def check_umask_setting():
    results = {
        "분류": "시스템 설정",
        "코드": "U-56",
        "위험도": "상",
        "진단 항목": "UMASK 설정 관리",
        "진단 결과": "",
        "현황": [],
        "대응방안": "[양호]: UMASK 값이 022 이하로 설정된 경우\n[취약]: UMASK 값이 022 이하로 설정되지 않은 경우"
    }

    config_file = "/etc/profile"
    try:
        with open(config_file, 'r') as file:
            contents = file.read()
            if re.search(r'umask 022', contents):
                results["현황"].append("umask가 /etc/profile에서 022로 설정됨")
            else:
                results["진단 결과"] = "취약"
                results["현황"].append("umask가 /etc/profile에서 022로 설정되지 않음")

            if re.search(r'export umask', contents):
                results["현황"].append("/etc/profile에서 export umask로 설정됨")
            else:
                results["진단 결과"] = "취약"
                results["현황"].append("/etc/profile에서 export umask로 설정되지 않음")

    except FileNotFoundError:
        results["현황"].append(f"{config_file} 파일을 찾을 수 없습니다.")
    except Exception as e:
        results["현황"].append(f"파일 읽기 중 예외 발생: {str(e)}")

    if "취약" not in results["진단 결과"]:
        results["진단 결과"] = "양호"

    return results

def main():
    results = check_umask_setting()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()