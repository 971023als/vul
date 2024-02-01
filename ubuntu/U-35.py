#!/usr/bin/python3
import re
import json

def check_apache_directory_listing():
    results = {
        "분류": "웹 서비스",
        "코드": "U-35",
        "위험도": "상",
        "진단 항목": "Apache 디렉터리 리스팅 제거",
        "진단 결과": "",
        "현황": [],
        "대응방안": "[양호]: 디렉터리 검색 기능을 사용하지 않는 경우\n[취약]: 디렉터리 검색 기능을 사용하는 경우"
    }

    config_file = "/etc/apache2/apache2.conf"
    try:
        with open(config_file, 'r') as file:
            contents = file.read()
            # Apache 구성 파일에서 "Options Indexes" 설정을 검색합니다.
            if re.search(r'^\s*Options\s+.*Indexes', contents, re.MULTILINE):
                results["진단 결과"] = "취약"
                results["현황"].append("Apache2 서버에서 디렉터리 목록이 사용 가능합니다.")
            else:
                results["진단 결과"] = "양호"
                results["현황"].append("Apache2 서버에서 디렉터리 목록이 사용 가능하지 않습니다.")
    except FileNotFoundError:
        results["현황"].append(f"{config_file} 파일을 찾을 수 없습니다.")
    except Exception as e:
        results["현황"].append(f"파일 읽기 중 예외 발생: {str(e)}")

    return results

def main():
    results = check_apache_directory_listing()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
