#!/usr/bin/python3
import re
import json

def check_apache_link_usage_restriction():
    results = {
        "분류": "웹 서비스",
        "코드": "U-39",
        "위험도": "상",
        "진단 항목": "Apache 링크 사용 금지",
        "진단 결과": "",
        "현황": [],
        "대응방안": "[양호]: 심볼릭 링크, aliases 사용을 제한한 경우\n[취약]: 심볼릭 링크, aliases 사용을 제한하지 않은 경우"
    }

    config_file = "/etc/apache2/apache2.conf"
    try:
        with open(config_file, 'r') as file:
            contents = file.read()
            symlink_result = re.search(r'^\s*Options\s.*FollowSymLinks', contents, re.MULTILINE)
            alias_result = re.search(r'^\s*Options\s.*SymLinksIfOwnerMatch', contents, re.MULTILINE)

            if symlink_result and alias_result:
                results["진단 결과"] = "취약"
                results["현황"].append("Apache2에서 심볼릭 링크 및 별칭이 허용됨")
            else:
                results["진단 결과"] = "양호"
                results["현황"].append("Apache2에서는 심볼릭 링크 및 별칭이 제한됩니다.")
    except FileNotFoundError:
        results["현황"].append(f"{config_file} 파일을 찾을 수 없습니다.")
    except Exception as e:
        results["현황"].append(f"파일 읽기 중 예외 발생: {str(e)}")

    return results

def main():
    results = check_apache_link_usage_restriction()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
