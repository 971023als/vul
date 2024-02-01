#!/usr/bin/python3
import os
import stat
import subprocess
import json

def check_at_command_and_file_permissions():
    results = {
        "분류": "시스템 설정",
        "코드": "U-65",
        "위험도": "상",
        "진단 항목": "at 파일 소유자 및 권한 설정",
        "진단 결과": "",
        "현황": [],
        "대응방안": "[양호]: at 접근제어 파일의 소유자가 root이고, 권한이 640 이하인 경우\n[취약]: at 접근제어 파일의 소유자가 root가 아니거나, 권한이 640 이하가 아닌 경우"
    }

    # at 명령의 사용 가능 여부를 확인합니다.
    at_command_available = subprocess.run(["command", "-v", "at"], capture_output=True).returncode == 0
    if at_command_available:
        results["현황"].append("at 명령을 사용할 수 있습니다.")
    else:
        results["현황"].append("at 명령을 사용할 수 없습니다.")

    # at 관련 파일의 사용 권한을 확인합니다.
    at_dir = "/etc/at.allow"
    if os.path.isfile(at_dir):
        file_stat = os.stat(at_dir)
        permission = stat.S_IMODE(file_stat.st_mode)
        if permission > 0o640:
            results["진단 결과"] = "취약"
            results["현황"].append(f"관련 파일({at_dir})의 권한이 640 이상입니다: 현재 권한 {oct(permission)}")
        else:
            results["현황"].append(f"관련 파일({at_dir})의 권한이 640 미만입니다.")
    else:
        results["현황"].append(f"관련 파일({at_dir})이 존재하지 않습니다.")

    if "취약" not in results["진단 결과"]:
        results["진단 결과"] = "양호"

    return results

def main():
    results = check_at_command_and_file_permissions()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()