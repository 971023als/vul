#!/usr/bin/python3
import subprocess
import json

def check_apache_symlink_restrictions():
    results = {
        "분류": "웹 서버 설정",
        "코드": "U-39",
        "위험도": "상",
        "진단 항목": "Apache 링크 사용 금지",
        "진단 결과": "",
        "현황": [],
        "대응방안": "[양호]: 심볼릭 링크, aliases 사용을 제한한 경우\n[취약]: 심볼릭 링크, aliases 사용을 제한하지 않은 경우"
    }

    config_file = "/etc/httpd/conf/httpd.conf"
    
    try:
        with open(config_file, 'r') as file:
            content = file.read()
            symlink_result = "FollowSymLinks" in content
            alias_result = "SymLinksIfOwnerMatch" in content

            if symlink_result and alias_result:
                results["진단 결과"] = "취약"
                results["현황"].append("Apache에서 심볼릭 링크 및 별칭 사용이 허용됩니다.")
            else:
                results["진단 결과"] = "양호"
                results["현황"].append("Apache에서 심볼릭 링크 및 별칭 사용이 제한됩니다.")
    except FileNotFoundError:
        results["현황"].append(f"{config_file} 파일을 찾을 수 없습니다.")
    except Exception as e:
        results["현황"].append(f"오류 발생: {str(e)}")

    return results

def main():
    results = check_apache_symlink_restrictions()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
