import subprocess
import os
import json

# 결과를 저장할 딕셔너리
results = {
    "U-16": {
        "title": "/dev에 존재하지 않는 device 파일 점검",
        "status": "",
        "description": {
            "good": "dev에 대한 파일 점검 후 존재하지 않은 device 파일을 제거한 경우",
            "bad": "dev에 대한 파일 미점검, 또는, 존재하지 않은 device 파일을 방치한 경우",
        },
        "devices": []
    }
}

def check_dev_files():
    # /dev 디렉토리 내의 파일 점검
    cmd = ['find', '/dev', '-type', 'f']
    proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    out, err = proc.communicate()

    if err:
        results["U-16"]["status"] = "오류"
        results["U-16"]["message"] = "장치 파일 검색 중 오류 발생: " + err
        return

    for line in out.splitlines():
        file_stat_cmd = ['stat', '-c', '%F %t %T', line]
        file_stat_proc = subprocess.Popen(file_stat_cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        stat_out, stat_err = file_stat_proc.communicate()

        if "0 0" in stat_out:
            results["U-16"]["devices"].append(f"{line} 메이저 및 마이너 번호가 없는 장치를 찾았습니다")
            results["U-16"]["status"] = "취약"
        else:
            results["U-16"]["devices"].append(f"{line} 메이저 및 마이너 번호가 있습니다")

    if not results["U-16"]["devices"]:
        results["U-16"]["status"] = "양호"
        results["U-16"]["message"] = "모든 장치 파일이 올바르게 구성되어 있습니다."
    else:
        results["U-16"]["message"] = results["U-16"]["description"]["bad"]

# 검사 수행
check_dev_files()

# 결과를 JSON 파일로 저장
with open('result.json', 'w', encoding='utf-8') as f:
    json.dump(results, f, ensure_ascii=False, indent=4)

# 결과 출력
print(json.dumps(results, ensure_ascii=False, indent=4))
