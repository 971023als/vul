#!/usr/bin/python3
import re
import json

def check_password_min_length():
    results = {
        "분류": "시스템 설정",
        "코드": "U-46",
        "위험도": "상",
        "진단 항목": "패스워드 최소 길이 설정",
        "진단 결과": "",
        "현황": [],
        "대응방안": "[양호]: 패스워드 최소 길이가 8자 이상으로 설정되어 있는 경우\n[취약]: 패스워드 최소 길이가 8자 미만으로 설정되어 있는 경우"
    }

    config_file = "/etc/login.defs"
    min_pass_length = 8
    try:
        with open(config_file, 'r') as file:
            for line in file:
                if "PASS_MIN_LEN" in line and not line.startswith("#"):
                    value = int(re.search(r'\d+', line).group())
                    if value >= min_pass_length:
                        results["진단 결과"] = "양호"
                        results["현황"].append(f"PASS_MIN_LEN이 {value}으로 설정되어 {min_pass_length}보다 크거나 같습니다.")
                    else:
                        results["진단 결과"] = "취약"
                        results["현황"].append(f"PASS_MIN_LEN이 {min_pass_length}보다 작은 {value}으로 설정되었습니다.")
                    break
            else:  # If PASS_MIN_LEN is not found in the file
                results["현황"].append("PASS_MIN_LEN 설정을 찾을 수 없습니다.")
    except FileNotFoundError:
        results["현황"].append(f"{config_file} 파일을 찾을 수 없습니다.")
    except Exception as e:
        results["현황"].append(f"파일 읽기 중 예외 발생: {str(e)}")

    return results

def main():
    results = check_password_min_length()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
