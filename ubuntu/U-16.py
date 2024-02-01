#!/usr/bin/python3
import subprocess
import json

def check_dev_nonexistent_device_files():
    results = {
        "분류": "시스템 파일 설정",
        "코드": "U-16",
        "위험도": "상",
        "진단 항목": "/dev에 존재하지 않는 device 파일 점검",
        "진단 결과": "",
        "현황": [],
        "대응방안": "/dev에 존재하지 않는 device 파일 제거 권장."
    }

    # /dev 디렉토리 내 모든 파일에 대한 메이저 및 마이너 번호 확인
    cmd = "find /dev -type b -o -type c -exec ls -l {} \;"
    process = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    stdout, stderr = process.communicate()

    nonexistent_device_files_found = False
    for line in stdout.split('\n'):
        if line:
            major_minor = ' '.join(line.split()[4:6])
            if major_minor == "0 0":
                results["현황"].append(f"메이저 및 마이너 번호가 없는 장치 파일 발견: {line.split()[-1]}")
                nonexistent_device_files_found = True

    if nonexistent_device_files_found:
        results["진단 결과"] = "취약"
    else:
        results["진단 결과"] = "양호"
        results["현황"].append("/dev에 존재하지 않는 device 파일 없음.")

    return results

def main():
    results = check_dev_nonexistent_device_files()
    # 결과를 JSON 형태로 출력
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
