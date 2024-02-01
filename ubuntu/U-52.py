#!/usr/bin/python3
import collections
import json

def check_duplicate_uids():
    results = {
        "분류": "시스템 설정",
        "코드": "U-52",
        "위험도": "상",
        "진단 항목": "동일한 UID 금지",
        "진단 결과": "",
        "현황": [],
        "대응방안": "양호: 동일한 UID로 설정된 사용자 계정이 존재하지 않는 경우\n취약: 동일한 UID로 설정된 사용자 계정이 존재하는 경우"
    }

    passwd_file = "/etc/passwd"
    try:
        with open(passwd_file, 'r') as file:
            uid_list = [line.split(":")[2] for line in file.readlines()]
            uid_counts = collections.Counter(uid_list)
            duplicate_uids = [uid for uid, count in uid_counts.items() if count > 1]

            if duplicate_uids:
                results["진단 결과"] = "취약"
                results["현황"].append(f"UID가 동일한 사용자 계정이 있습니다: {', '.join(duplicate_uids)}")
            else:
                results["진단 결과"] = "양호"
                results["현황"].append("같은 UID를 가진 사용자 계정이 없습니다.")
    except FileNotFoundError:
        results["현황"].append(f"{passwd_file} 파일이 없습니다.")
    except Exception as e:
        results["현황"].append(f"파일 읽기 중 예외 발생: {str(e)}")

    return results

def main():
    results = check_duplicate_uids()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
