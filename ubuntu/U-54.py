#!/usr/bin/python3
import re
import json

def check_session_timeout():
    results = {
        "분류": "시스템 설정",
        "코드": "U-54",
        "위험도": "상",
        "진단 항목": "Session Timeout 설정",
        "진단 결과": "",
        "현황": [],
        "대응방안": "[양호]: Session Timeout이 600초(10분) 이하로 설정되어 있는 경우\n[취약]: Session Timeout이 600초(10분) 이하로 설정되지 않은 경우"
    }

    config_file = "/etc/profile"
    try:
        with open(config_file, 'r') as file:
            contents = file.read()
            if re.search(r'^TMOUT=600$', contents, re.MULTILINE):
                results["진단 결과"] = "양호"
                results["현황"].append("/etc/profile에서 TMOUT가 600으로 설정됨")
            else:
                results["진단 결과"] = "취약"
                results["현황"].append("/etc/profile에서 TMOUT가 600으로 설정되지 않음")
    except FileNotFoundError:
        results["현황"].append(f"{config_file} 파일을 찾을 수 없습니다.")
    except Exception as e:
        results["현황"].append(f"파일 읽기 중 예외 발생: {str(e)}")

    return results

def main():
    results = check_session_timeout()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
