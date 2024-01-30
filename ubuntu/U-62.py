#!/usr/bin/env python3
import json
import re
import subprocess

# 결과를 저장할 딕셔너리
results = {
    "U-62": {
        "title": "ftp 계정 shell 제한",
        "status": "",
        "description": {
            "good": "ftp 계정에 /bin/false 쉘이 부여되어 있는 경우",
            "bad": "ftp 계정에 /bin/false 쉘이 부여되지 않는 경우"
        },
        "details": []
    }
}

def check_ftp_account_shell():
    try:
        with open('/etc/passwd', 'r') as f:
            passwd_content = f.read()
        
        ftp_entry_match = re.search(r'^ftp:.*', passwd_content, re.MULTILINE)
        if ftp_entry_match:
            ftp_shell = re.search(r'^ftp:.*:(/bin/false)$', passwd_content, re.MULTILINE)
            if ftp_shell:
                results["U-62"]["details"].append("FTP 계정의 셸이 /bin/false로 설정되었습니다.")
                results["U-62"]["status"] = "양호"
            else:
                results["U-62"]["details"].append("FTP 계정의 셸이 /bin/false로 설정되지 않습니다.")
                results["U-62"]["status"] = "취약"
        else:
            results["U-62"]["details"].append("FTP 계정이 존재하지 않습니다.")
            results["U-62"]["status"] = "양호"  # FTP 계정이 없으므로 양호한 상태로 간주할 수 있습니다.

    except Exception as e:
        results["U-62"]["details"].append(f"오류 발생: {str(e)}")
        results["U-62"]["status"] = "정보"

check_ftp_account_shell()

# 결과 파일에 JSON 형태로 저장
result_file = 'ftp_account_shell_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
