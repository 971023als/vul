#!/usr/bin/python3
import re
import json

def check_password_max_age():
    results = {
        "분류": "시스템 설정",
        "코드": "U-47",
        "위험도": "상",
        "진단 항목": "패스워드 최대 사용기간 설정",
        "진단 결과": "",
        "현황": [],
        "대응방안": "[양호]: 패스워드 최대 사용기간이 90일(12주) 이하로 설정되어 있는 경우\n[취약]: 패스워드 최대 사용기간이 90일(12주) 이하로 설정되어 있지 않은 경우"
    }

    config_file = "/etc/login.defs"
    max_days = 90
    try:
        with open(config_file, 'r') as file:
            for line in file:
                if "PASS_MAX_DAYS" in line and not line.startswith("#"):
                    value = int(re.search(r'\d+', line).group())
                    if value <= max_days:
                        results["진단 결과"] = "양호"
                        results["현황"].append(f"PASS_MAX_DAYS가 {value}일로 설정되어 {max_days}일 보다 작거나 같습니다.")
                    else:
                        results["진단 결과"] = "취약"
                        results["현황"].append(f"PASS_MAX_DAYS가 {max_days}일 보다 큰 {value}일로 설정되었습니다.")
                    break
            else:  # If PASS_MAX_DAYS is not found in the file
                results["현황"].append("PASS_MAX_DAYS 설정을 찾을 수 없습니다.")
    except FileNotFoundError:
        results["현황"].append(f"{config_file} 파일을 찾을 수 없습니다.")
    except Exception as e:
        results["현황"].append(f"파일 읽기 중 예외 발생: {str(e)}")

    return results

def main():
    results = check_password_max_age()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
