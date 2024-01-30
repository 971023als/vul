#!/usr/bin/env python3
import json
import subprocess

# 결과를 저장할 딕셔너리
results = {
    "U-16": {
        "title": "/dev에 존재하지 않는 device 파일 점검",
        "status": "",
        "description": {
            "good": "dev에 대한 파일 점검 후 존재하지 않은 device 파일을 제거한 경우",
            "bad": "dev에 대한 파일 미점검, 또는, 존재하지 않은 device 파일을 방치한 경우"
        },
        "details": []
    }
}

def check_device_files():
    # /dev 디렉토리에서 파일 타입의 객체를 찾아 메이저 및 마이너 번호를 검사
    command = "find /dev -type f -exec ls -l {} \;"
    process = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    stdout, stderr = process.communicate()

    if stdout:
        for line in stdout.split('\n'):
            if line:
                major_minor = line.split()[4:6]
                if major_minor == ['0', '0']:
                    results["U-16"]["status"] = "취약"
                    results["U-16"]["details"].append(f"{line} 메이저 및 마이너 번호가 없는 장치를 찾았습니다.")
                else:
                    results["U-16"]["details"].append(f"{line} 메이저 및 마이너 번호가 있습니다.")
    else:
        results["U-16"]["status"] = "양호"
        results["U-16"]["details"].append("존재하지 않는 device 파일이 /dev에 없습니다.")

check_device_files()

# 결과 파일에 JSON 형태로 저장
result_file = 'dev_nonexistent_device_files_check_result.json'
with open(result_file, 'w') as file:
    json.dump(results, file, indent=4, ensure_ascii=False)

# 결과 콘솔에 출력
print(json.dumps(results, indent=4, ensure_ascii=False))
