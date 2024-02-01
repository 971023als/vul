#!/usr/bin/python3
import subprocess
import os
import json

def check_unwanted_apache_files():
    results = {
        "분류": "웹 서비스",
        "코드": "U-38",
        "위험도": "상",
        "진단 항목": "Apache 불필요한 파일 제거",
        "진단 결과": "",
        "현황": [],
        "대응방안": "[양호]: 매뉴얼 파일 및 디렉터리가 제거되어 있는 경우\n[취약]: 매뉴얼 파일 및 디렉터리가 제거되지 않은 경우"
    }

    httpd_root = "/etc/apache2"  # Apache 설정 파일의 루트 디렉터리
    unwanted_items = ["manual", "samples", "docs"]

    try:
        # Apache 실행 상태 확인
        apache_process_count = subprocess.check_output(["pgrep", "-fc", "apache2"], text=True).strip()
        if apache_process_count == "0":
            results["현황"].append("아파치가 실행되지 않습니다.")
        else:
            for item in unwanted_items:
                item_path = os.path.join(httpd_root, item)
                if not os.path.exists(item_path):
                    results["현황"].append(f"{item} 을 {httpd_root} 에서 찾을 수 없습니다.")
                else:
                    results["진단 결과"] = "취약"
                    results["현황"].append(f"{item} 을 {httpd_root} 에서 찾을 수 있습니다.")
    except subprocess.CalledProcessError:
        results["현황"].append("아파치 실행 상태 확인 중 오류 발생")
    except Exception as e:
        results["현황"].append(f"예외 발생: {str(e)}")

    # 진단 결과 설정
    if "취약" not in results["진단 결과"] and "아파치가 실행되지 않습니다." not in results["현황"]:
        results["진단 결과"] = "양호"

    return results

def main():
    results = check_unwanted_apache_files()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
