#!/usr/bin/python3
import re
import json

def check_apache_document_root_separation():
    results = {
        "분류": "웹 서버 설정",
        "코드": "U-41",
        "위험도": "상",
        "진단 항목": "Apache 웹 서비스 영역의 분리",
        "진단 결과": "",
        "현황": [],
        "대응방안": "[양호]: DocumentRoot를 별도의 디렉터리로 지정한 경우\n[취약]: DocumentRoot를 기본 디렉터리로 지정한 경우"
    }

    config_file = "/etc/httpd/conf/httpd.conf"
    
    try:
        with open(config_file, 'r') as file:
            content = file.read()
            document_root_match = re.search(r'^DocumentRoot\s+"([^"]+)"', content, re.MULTILINE)
            if document_root_match:
                document_root = document_root_match.group(1)
                if document_root != "/var/www/html":
                    results["진단 결과"] = "양호"
                    results["현황"].append(f"DocumentRoot가 별도의 디렉터리로 설정되었습니다: {document_root}")
                else:
                    results["진단 결과"] = "취약"
                    results["현황"].append("DocumentRoot가 기본 경로로 설정되었습니다: /var/www/html")
            else:
                results["현황"].append("DocumentRoot 설정을 찾을 수 없습니다.")
    except FileNotFoundError:
        results["현황"].append(f"{config_file} 파일을 찾을 수 없습니다.")
    except Exception as e:
        results["현황"].append(f"오류 발생: {str(e)}")

    return results

def main():
    results = check_apache_document_root_separation()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
