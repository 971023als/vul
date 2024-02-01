#!/usr/bin/python3
import re
import json

def check_nfs_access_control():
    results = {
        "분류": "시스템 설정",
        "코드": "U-25",
        "위험도": "상",
        "진단 항목": "NFS 서비스 접근 통제",
        "진단 결과": "",
        "현황": [],
        "대응방안": "[양호]: 불필요한 NFS 서비스가 비활성화 되어있는 경우\n[취약]: 불필요한 NFS 서비스가 활성화 되어있는 경우"
    }

    try:
        with open('/etc/exports', 'r') as file:
            exports_content = file.read()
            # Regex to find lines without 'no_root_squash' for 'everyone'
            if re.search(r'^[^#].*\severyone(?!.*no_root_squash)', exports_content, re.MULTILINE):
                results["진단 결과"] = "취약"
                results["현황"].append("NFS는 '모두' 그룹에 대한 제한 없이 수출을 공유하고 있습니다.")
            else:
                results["진단 결과"] = "양호"
                results["현황"].append("NFS는 '모두' 그룹에 대한 제한 없이 수출을 공유하지 않습니다.")
    except FileNotFoundError:
        results["진단 결과"] = "양호"
        results["현황"].append("/etc/exports 파일이 존재하지 않습니다.")

    return results

def main():
    results = check_nfs_access_control()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
