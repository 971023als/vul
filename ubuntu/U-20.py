#!/usr/bin/python3

import subprocess
import json

def check_anonymous_ftp_status():
    results = {
        "분류": "서비스 관리",
        "코드": "U-20",
        "위험도": "상",
        "진단 항목": "Anonymous FTP 비활성화",
        "진단 결과": "",
        "현황": "",
        "대응방안": "Anonymous FTP 접속을 차단하세요."
    }

    try:
        # Check if the ftp account exists in /etc/passwd
        process = subprocess.run(['grep', '^ftp:', '/etc/passwd'], check=False, capture_output=True, text=True)
        if process.stdout:
            results["진단 결과"] = "취약"
            results["현황"] = "FTP 계정이 /etc/passwd 파일에 있습니다. Anonymous FTP 접속이 가능할 수 있습니다."
        else:
            results["진단 결과"] = "양호"
            results["현황"] = "FTP 계정이 /etc/passwd 파일에 없습니다. Anonymous FTP 접속이 차단되었을 가능성이 높습니다."
    except Exception as e:
        results["진단 결과"] = "확인 불가"
        results["현황"] = str(e)

    return results

def main():
    results = check_anonymous_ftp_status()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
