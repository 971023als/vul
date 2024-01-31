#!/bin/python3

import os
import json

def check_path_environment_variable():
    results = []
    path_env_var = os.environ.get("PATH", "")
    
    # PATH 환경변수 시작 부분에 '.'이 있는지 확인
    if path_env_var.startswith("."):
        results.append({
            "코드": "U-05",
            "진단 결과": "취약",
            "현황": "PATH 변수의 시작 부분에서 '.' 발견됨",
            "대응방안": "PATH에서 '.' 제거 권장",
            "결과": "경고"
        })
    else:
        results.append({
            "코드": "U-05",
            "진단 결과": "양호",
            "현황": "PATH 변수의 시작 부분에서 '.' 발견되지 않음",
            "대응방안": "현재 설정 유지",
            "결과": "정상"
        })
    
    # PATH 환경변수 중간에 '.'이 있는지 확인
    if " :." in path_env_var or path_env_var.endswith(":.") :
        results.append({
            "코드": "U-05",
            "진단 결과": "취약",
            "현황": "PATH 변수의 중간 부분에서 '.' 발견됨",
            "대응방안": "PATH에서 '.' 제거 권장",
            "결과": "경고"
        })
    else:
        # 시작 부분에서 '.'이 없다고 판단된 경우에만 추가적으로 정상 결과 추가
        if not path_env_var.startswith("."):
            results.append({
                "코드": "U-05",
                "진단 결과": "양호",
                "현황": "PATH 변수의 중간 부분에서 '.' 발견되지 않음",
                "대응방안": "현재 설정 유지",
                "결과": "정상"
            })

    return results

def save_results_to_json(results, file_path):
    with open(file_path, 'w') as f:
        json.dump(results, f, ensure_ascii=False, indent=4)

def main():
    results = check_path_environment_variable()
    save_results_to_json(results, "path_environment_variable_check_result.json")
    print("root 홈, 패스 디렉토리 권한 및 PATH 설정 점검 결과를 path_environment_variable_check_result.json 파일에 저장하였습니다.")

if __name__ == "__main__":
    main()


