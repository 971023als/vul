#!/usr/bin/python3
import subprocess
import json

def check_apache_process_permissions():
    results = {
        "분류": "웹 서버 설정",
        "코드": "U-36",
        "위험도": "상",
        "진단 항목": "Apache 웹 프로세스 권한 제한",
        "진단 결과": "",
        "현황": [],
        "대응방안": "[양호]: Apache 데몬이 root 권한으로 구동되지 않는 경우\n[취약]: Apache 데몬이 root 권한으로 구동되는 경우"
    }

    try:
        # Check if the Apache daemon (httpd) is running
        process = subprocess.run(['pgrep', '-x', 'httpd'], capture_output=True, text=True, check=False)
        if process.returncode == 0:
            results["현황"].append("아파치 데몬(httpd)이 실행 중입니다.")
            # Get the user and group of the httpd process
            process_id = process.stdout.strip()
            user = subprocess.run(['ps', '-o', 'user=', '-p', process_id], capture_output=True, text=True).stdout.strip()
            group = subprocess.run(['ps', '-o', 'group=', '-p', process_id], capture_output=True, text=True).stdout.strip()

            if user == "root" or group == "root":
                results["진단 결과"] = "취약"
                results["현황"].append("Apache 데몬(httpd)이 루트 권한으로 실행되고 있습니다.")
            else:
                results["진단 결과"] = "양호"
                results["현황"].append("Apache 데몬(httpd)이 루트 권한으로 실행되지 않습니다.")
        else:
            results["진단 결과"] = "양호"
            results["현황"].append("아파치 데몬(httpd)이 실행되고 있지 않습니다.")
    except Exception as e:
        results["현황"].append(f"오류 발생: {str(e)}")

    return results

def main():
    results = check_apache_process_permissions()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
