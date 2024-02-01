#!/usr/bin/python3
import subprocess
import json

def check_apache_file_upload_download_limits():
    results = {
        "분류": "웹 서버 설정",
        "코드": "U-40",
        "위험도": "상",
        "진단 항목": "Apache 파일 업로드 및 다운로드 제한",
        "진단 결과": "",
        "현황": [],
        "대응방안": "[양호]: 파일 업로드 및 다운로드를 제한한 경우\n[취약]: 파일 업로드 및 다운로드를 제한하지 않은 경우"
    }

    config_file = "/etc/httpd/conf/httpd.conf"
    
    try:
        with open(config_file, 'r') as file:
            content = file.read()
            upload_result = "LimitRequestBody" in content
            download_result = "LimitXMLRequestBody" in content
            upload_size_result = "LimitUploadSize" in content

            if upload_result or download_result or upload_size_result:
                results["진단 결과"] = "양호"
                results["현황"].append("Apache에서 파일 업로드 및 다운로드 제한이 설정되었습니다.")
            else:
                results["진단 결과"] = "취약"
                results["현황"].append("Apache에서 파일 업로드 및 다운로드 제한이 설정되지 않았습니다.")
    except FileNotFoundError:
        results["현황"].append(f"{config_file} 파일을 찾을 수 없습니다.")
    except Exception as e:
        results["현황"].append(f"오류 발생: {str(e)}")

    return results

def main():
    results = check_apache_file_upload_download_limits()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
