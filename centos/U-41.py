#!/usr/bin/python3
import subprocess
import os
import json

def check_web_service_area_separation():
    results = {
        "분류": "서비스 관리",
        "코드": "U-41",
        "위험도": "상",
        "진단 항목": "웹서비스 영역의 분리",
        "진단 결과": "양호",  # Assume "Good" until proven otherwise
        "현황": [],
        "대응방안": "DocumentRoot 별도 디렉터리 지정"
    }

    webconf_files = [".htaccess", "httpd.conf", "apache2.conf"]
    document_root_set = False
    vulnerable = False

    for conf_file in webconf_files:
        find_command = f"find / -name {conf_file} -type f 2>/dev/null"
        try:
            find_output = subprocess.check_output(find_command, shell=True, text=True).strip().split('\n')
            for file_path in find_output:
                if file_path:
                    with open(file_path, 'r') as file:
                        for line in file:
                            if 'DocumentRoot' in line and not line.strip().startswith('#'):
                                document_root_set = True
                                path = line.split()[1].strip('"')
                                if path in ['/usr/local/apache/htdocs', '/usr/local/apache2/htdocs', '/var/www/html']:
                                    vulnerable = True
                                    break
        except subprocess.CalledProcessError:
            continue  # Skip to the next file if the find command encounters an error

    if not document_root_set:
        results["진단 결과"] = "취약"
        results["현황"].append("Apache DocumentRoot가 설정되지 않았습니다.")
    elif vulnerable:
        results["진단 결과"] = "취약"
        results["현황"].append("Apache DocumentRoot를 기본 디렉터리로 설정했습니다.")
    else:
        results["현황"].append("Apache DocumentRoot가 별도의 디렉터리로 적절히 설정되어 있습니다.")

    return results

def main():
    results = check_web_service_area_separation()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
