#!/usr/bin/python3
import os
import json
import glob

def get_umask_values_from_file(file_path):
    """Extracts and returns umask values found in the given file."""
    umask_values = []
    with open(file_path, 'r') as file:
        for line in file:
            if 'umask' in line and not line.strip().startswith('#'):
                parts = line.split()
                for part in parts:
                    if 'umask' in part:
                        value = part.split('=')[-1] if '=' in part else parts[-1]
                        umask_values.append(value.strip('`'))
    return umask_values

def check_umask_settings():
    results = {
        "분류": "파일 및 디렉토리 관리",
        "코드": "U-56",
        "위험도": "중",
        "진단 항목": "UMASK 설정 관리",
        "진단 결과": "양호",  # Assume "Good" until proven otherwise
        "현황": [],
        "대응방안": "UMASK 값이 022 이상으로 설정"
    }

    # Files to check for UMASK settings
    files_to_check = ["/etc/profile", "/etc/bashrc", "/etc/csh.login", "/etc/csh.cshrc"]
    files_to_check += glob.glob("/home/*/.profile") + glob.glob("/home/*/.bashrc") + glob.glob("/home/*/.cshrc") + glob.glob("/home/*/.login")

    vulnerable = False

    for file_path in files_to_check:
        if os.path.isfile(file_path):
            umask_values = get_umask_values_from_file(file_path)
            for value in umask_values:
                # Check if the UMASK value is less restrictive than 022
                if len(value) == 3 and int(value) < 22:
                    results["진단 결과"] = "취약"
                    results["현황"].append(f"{file_path} 파일에서 UMASK 값 ({value})이 022 이상으로 설정되지 않았습니다.")
                    vulnerable = True
                elif len(value) == 4 and int(value[1:]) < 22:
                    results["진단 결과"] = "취약"
                    results["현황"].append(f"{file_path} 파일에서 UMASK 값 ({value})이 022 이상으로 설정되지 않았습니다.")
                    vulnerable = True

    if not vulnerable:
        # If no files were found to have inappropriate UMASK settings
        results["진단 결과"] = "양호"

    return results

def main():
    umask_settings_check_results = check_umask_settings()
    print(json.dumps(umask_settings_check_results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()

