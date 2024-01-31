#!/bin/python3

import os

def check_root_remote_access():
    sshd_config_file = "/etc/ssh/sshd_config"
    results = []

    # sshd_config 파일이 있는지 확인합니다.
    if not os.path.isfile(sshd_config_file):
        results.append({
            "코드": "U-01",
            "진단 결과": "파일 없음",
            "현황": "/etc/ssh/sshd_config 파일이 없습니다. 확인해주세요.",
            "대응방안": "SSH 서비스 설정 확인 및 적절한 설정 적용",
            "결과": "정보"
        })
        return results

    # sshd_config 파일에서 PermitRootLogin 설정 검색
    with open(sshd_config_file, 'r') as file:
        for line in file:
            if line.strip().startswith("PermitRootLogin"):
                if "yes" in line.split():
                    results.append({
                        "코드": "U-01",
                        "진단 결과": "취약",
                        "현황": "원격 터미널 서비스를 통해 루트 직접 액세스가 허용됨",
                        "대응방안": "PermitRootLogin 설정을 'no'로 변경 권장",
                        "결과": "경고"
                    })
                else:
                    results.append({
                        "코드": "U-01",
                        "진단 결과": "양호",
                        "현황": "원격 터미널 서비스를 통해 루트 직접 액세스가 허용되지 않음",
                        "대응방안": "현재 설정 유지",
                        "결과": "정상"
                    })
                break
        else:  # PermitRootLogin 설정이 명시적으로 존재하지 않는 경우
            results.append({
                "코드": "U-01",
                "진단 결과": "정보",
                "현황": "PermitRootLogin 설정이 명시적으로 존재하지 않습니다.",
                "대응방안": "PermitRootLogin 설정을 명시적으로 'no'로 설정 권장",
                "결과": "정보"
            })

    return results

def save_results_to_json(results, file_path):
    import json
    with open(file_path, 'w') as f:
        json.dump(results, f, ensure_ascii=False, indent=4)

def main():
    results = check_root_remote_access()
    save_results_to_json(results, "root_remote_access_check_result.json")
    print("root 계정 원격 접속 제한 설정 점검 결과를 root_remote_access_check_result.json 파일에 저장하였습니다.")

if __name__ == "__main__":
    main()
