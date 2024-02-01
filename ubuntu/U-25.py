#!/usr/bin/python3
import re
import json

def check_nfs_exports_access_control():
    results = {
        "분류": "시스템 관리",
        "코드": "U-25",
        "위험도": "상",
        "진단 항목": "NFS 서비스 접근 통제",
        "진단 결과": "",
        "현황": [],
        "대응방안": "[양호]: 불필요한 NFS 서비스가 비활성화 되어있는 경우\n[취약]: 불필요한 NFS 서비스가 활성화 되어있는 경우"
    }

    try:
        with open('/etc/exports', 'r') as file:
            exports_contents = file.read()
            # 정규 표현식을 사용하여 "everyone" 그룹에 대한 제한 없는 공유를 확인합니다.
            if re.search(r'^[^#].*\s+everyone(?!.*no_root_squash)', exports_contents, re.MULTILINE):
                results["진단 결과"] = "취약"
                results["현황"].append("NFS는 '모두' 그룹에 대한 제한 없이 수출을 공유하고 있습니다.")
            else:
                results["진단 결과"] = "양호"
                results["현황"].append("NFS는 '모두' 그룹에 대한 제한 없이 수출을 공유하지 않습니다.")
    except FileNotFoundError:
        results["현황"].append("/etc/exports 파일을 찾을 수 없습니다.")
    except Exception as e:
        results["현황"].append(f"파일을 분석하는 도중 예외가 발생했습니다: {str(e)}")

    return results

def main():
    results = check_nfs_exports_access_control()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
