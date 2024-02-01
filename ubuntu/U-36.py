#!/usr/bin/python3
import subprocess
import json

def check_apache_process_permissions():
    results = {
        "분류": "웹 서비스",
        "코드": "U-36",
        "위험도": "상",
        "진단 항목": "Apache 웹 프로세스 권한 제한",
        "진단 결과": "",
        "현황": [],
        "대응방안": "[양호]: Apache 데몬이 root 권한으로 구동되지 않는 경우\n[취약]: Apache 데몬이 root 권한으로 구동되는 경우"
    }

    try:
        # Apache 데몬(httpd) 실행 상태 확인
        httpd_pids = subprocess.check_output(["pgrep", "-x", "httpd"], text=True).strip()
        if httpd_pids:
            results["현황"].append("아파치 데몬(httpd)이 실행 중입니다.")
            # httpd 프로세스의 사용자 및 그룹 가져오기
            httpd_user = subprocess.check_output(["ps", "-o", "user=", "-p", httpd_pids.split('\n')[0]], text=True).strip()
            httpd_group = subprocess.check_output(["ps", "-o", "group=", "-p", httpd_pids.split('\n')[0]], text=True).strip()

            # httpd 프로세스가 루트로 실행 중인지 확인
            if httpd_user == "root" or httpd_group == "root":
                results["진단 결과"] = "취약"
                results["현황"].append("Apache 데몬(httpd)이 루트 권한으로 실행되고 있습니다.")
            else:
                results["진단 결과"] = "양호"
                results["현황"].append("Apache 데몬(httpd)이 루트 권한으로 실행되지 않습니다.")
        else:
            results["현황"].append("아파치 데몬(httpd)이 실행되고 있지 않습니다.")
            results["진단 결과"] = "양호"
    except subprocess.CalledProcessError:
        results["현황"].append("아파치 데몬(httpd)의 실행 상태 확인 중 오류 발생")
    except Exception as e:
        results["현황"].append(f"예외 발생: {str(e)}")

    return results

def main():
    results = check_apache_process_permissions()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
