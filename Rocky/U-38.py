#!/usr/bin/python3
import subprocess
import os
import json

def check_unwanted_apache_files():
    results = {
        "분류": "웹 서버 설정",
        "코드": "U-38",
        "위험도": "상",
        "진단 항목": "Apache 불필요한 파일 제거",
        "진단 결과": "",
        "현황": [],
        "대응방안": "[양호]: 매뉴얼 파일 및 디렉터리가 제거되어 있는 경우\n[취약]: 매뉴얼 파일 및 디렉터리가 제거되지 않은 경우"
    }

    httpd_root = "/etc/httpd/conf"
    unwanted_items = ["manual", "samples", "docs"]

    try:
        # Check if Apache is running
        process = subprocess.run(['pgrep', '-f', 'httpd'], capture_output=True, text=True)
        if process.returncode == 0:
            results["현황"].append("아파치가 실행 중입니다.")
        else:
            results["현황"].append("아파치가 실행되지 않습니다.")
            return results

        # Check for unwanted items
        for item in unwanted_items:
            item_path = os.path.join(httpd_root, item)
            if os.path.exists(item_path):
                results["진단 결과"] = "취약"
                results["현황"].append(f"{item_path}이(가) 존재합니다.")
            else:
                results["현황"].append(f"{item_path}이(가) 존재하지 않습니다.")
        
        if results["진단 결과"] != "취약":
            results["진단 결과"] = "양호"

    except Exception as e:
        results["현황"].append(f"오류 발생: {str(e)}")

    return results

def main():
    results = check_unwanted_apache_files()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
