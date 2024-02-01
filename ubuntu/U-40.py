#!/usr/bin/python3
import re
import json

def check_apache_file_transfer_limits():
    results = {
        "분류": "웹 서비스",
        "코드": "U-40",
        "위험도": "상",
        "진단 항목": "Apache 파일 업로드 및 다운로드 제한",
        "진단 결과": "",
        "현황": [],
        "대응방안": "[양호]: 파일 업로드 및 다운로드를 제한한 경우\n[취약]: 파일 업로드 및 다운로드를 제한하지 않은 경우"
    }

    config_file = "/etc/apache2/apache2.conf"
    try:
        with open(config_file, 'r') as file:
            contents = file.read()
            upload_result = re.search(r'^\s*LimitRequestBody', contents, re.MULTILINE)
            download_result = re.search(r'^\s*LimitXMLRequestBody', contents, re.MULTILINE)

            if upload_result or download_result:
                results["진단 결과"] = "양호"
                results["현황"].append("Apache2에서 파일 업로드 및 다운로드가 제한됩니다.")
            else:
                results["진단 결과"] = "취약"
                results["현황"].append("Apache2에서 파일 업로드 및 다운로드가 제한되지 않습니다.")
    except FileNotFoundError:
        results["현황"].append(f"{config_file} 파일을 찾을 수 없습니다.")
    except Exception as e:
        results["현황"].append(f"파일 읽기 중 예외 발생: {str(e)}")

    return results

def main():
    results = check_apache_file_transfer_limits()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
