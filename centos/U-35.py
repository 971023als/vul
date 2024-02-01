#!/usr/bin/python3
import subprocess
import json

def check_apache_directory_listing():
    results = {
        "분류": "웹 서버 설정",
        "코드": "U-35",
        "위험도": "상",
        "진단 항목": "Apache 디렉터리 리스팅 제거",
        "진단 결과": "",
        "현황": [],
        "대응방안": "[양호]: 디렉터리 검색 기능을 사용하지 않는 경우\n[취약]: 디렉터리 검색 기능을 사용하는 경우"
    }

    config_file = "/etc/httpd/conf/httpd.conf"
    try:
        with open(config_file, 'r') as file:
            if 'Options Indexes' in file.read():
                results["진단 결과"] = "취약"
                results["현황"].append("Apache2 서버에서 디렉터리 목록이 사용 가능합니다.")
            else:
                results["진단 결과"] = "양호"
                results["현황"].append("Apache2 서버에서 디렉터리 목록이 사용 가능하지 않습니다.")
    except Exception as e:
        results["현황"].append(f"{config_file} 파일 열기 오류: {str(e)}")

    return results

def main():
    results = check_apache_directory_listing()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
