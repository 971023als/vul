#!/usr/bin/python3
import subprocess
import json

def check_apache_directory_access_restriction():
    results = {
        "분류": "웹 서버 설정",
        "코드": "U-37",
        "위험도": "상",
        "진단 항목": "Apache 상위 디렉터리 접근 금지",
        "진단 결과": "",
        "현황": [],
        "대응방안": "[양호]: 상위 디렉터리에 이동제한을 설정한 경우\n[취약]: 상위 디렉터리에 이동제한을 설정하지 않은 경우"
    }

    config_file = "/etc/httpd/conf/httpd.conf"
    allow_override_option = "AllowOverride AuthConfig"
    
    try:
        with open(config_file, 'r') as file:
            if allow_override_option in file.read():
                results["진단 결과"] = "양호"
                results["현황"].append(f"{config_file}에서 {allow_override_option}을 찾았습니다.")
            else:
                results["진단 결과"] = "취약"
                results["현황"].append(f"{config_file}에서 {allow_override_option}을 찾을 수 없습니다.")
    except FileNotFoundError:
        results["현황"].append(f"{config_file}을 찾을 수 없습니다.")
    except Exception as e:
        results["현황"].append(f"오류 발생: {str(e)}")

    return results

def main():
    results = check_apache_directory_access_restriction()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
