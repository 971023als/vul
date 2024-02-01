#!/usr/bin/python3
import os
import json

def check_apache_directory_access_restriction():
    results = {
        "분류": "웹 서비스",
        "코드": "U-37",
        "위험도": "상",
        "진단 항목": "Apache 상위 디렉터리 접근 금지",
        "진단 결과": "",
        "현황": [],
        "대응방안": "[양호]: 상위 디렉터리에 이동제한을 설정한 경우\n[취약]: 상위 디렉터리에 이동제한을 설정하지 않은 경우"
    }

    httpd_conf_file = "/etc/apache2/apache2.conf"
    allow_override_option = "AllowOverride AuthConfig"

    if not os.path.isfile(httpd_conf_file):
        results["현황"].append(f"{httpd_conf_file} 을 찾을 수 없습니다.")
    else:
        with open(httpd_conf_file, 'r') as file:
            contents = file.read()
            if allow_override_option in contents:
                results["진단 결과"] = "양호"
                results["현황"].append(f"{httpd_conf_file} 에서 {allow_override_option} 을 찾았습니다.")
            else:
                results["진단 결과"] = "취약"
                results["현황"].append(f"{httpd_conf_file} 에서 {allow_override_option} 을 찾을 수 없습니다.")

    return results

def main():
    results = check_apache_directory_access_restriction()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
