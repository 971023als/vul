#!/usr/bin/python3
import re
import json

def check_apache_document_root_separation():
    results = {
        "분류": "웹 서비스",
        "코드": "U-41",
        "위험도": "상",
        "진단 항목": "Apache 웹 서비스 영역의 분리",
        "진단 결과": "",
        "현황": [],
        "대응방안": "[양호]: DocumentRoot를 별도의 디렉터리로 지정한 경우\n[취약]: DocumentRoot를 기본 디렉터리로 지정한 경우"
    }

    config_file = "/etc/apache2/sites-available/000-default.conf"
    default_directory = "/var/www/html"
    try:
        with open(config_file, 'r') as file:
            contents = file.read()
            # DocumentRoot 설정을 검색합니다.
            match = re.search(r'DocumentRoot\s+([^\s]+)', contents)
            if match and match.group(1) == default_directory:
                results["진단 결과"] = "취약"
                results["현황"].append(f"DocumentRoot가 기본 경로로 설정되었습니다: {default_directory}")
            else:
                results["진단 결과"] = "양호"
                results["현황"].append("DocumentRoot가 기본 경로로 설정되지 않았습니다.")
    except FileNotFoundError:
        results["현황"].append(f"{config_file} 파일을 찾을 수 없습니다.")
    except Exception as e:
        results["현황"].append(f"파일 읽기 중 예외 발생: {str(e)}")

    return results

def main():
    results = check_apache_document_root_separation()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
