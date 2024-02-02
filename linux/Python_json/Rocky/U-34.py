#!/usr/bin/python3
import subprocess
import json

def check_dns_zone_transfer_settings():
    results = {
        "분류": "서비스 관리",
        "코드": "U-34",
        "위험도": "상",
        "진단 항목": "DNS Zone Transfer 설정",
        "진단 결과": None,  # 초기 상태 설정, 검사 후 결과에 따라 업데이트
        "현황": [],
        "대응방안": "Zone Transfer를 허가된 사용자에게만 허용"
    }

    named_conf_path = "/etc/named.conf"
    try:
        # DNS 서비스 실행 여부 확인
        ps_dns_count = subprocess.check_output("ps -ef | grep -i 'named' | grep -v 'grep'", shell=True, text=True).strip()
        if ps_dns_count:
            if os.path.isfile(named_conf_path):
                with open(named_conf_path, 'r') as file:
                    named_conf_contents = file.read()
                    # 'allow-transfer { any; }' 설정 검사
                    if "allow-transfer { any; }" in named_conf_contents:
                        results["진단 결과"] = "취약"
                        results["현황"].append("/etc/named.conf 파일에 allow-transfer { any; } 설정이 있습니다.")
                    else:
                        results["진단 결과"] = "양호"
                        results["현황"].append("DNS Zone Transfer가 허가된 사용자에게만 허용되어 있습니다.")
            else:
                results["진단 결과"] = "양호"
                results["현황"].append("/etc/named.conf 파일이 존재하지 않습니다. DNS 서비스 미사용 가능성.")
        else:
            results["진단 결과"] = "양호"
            results["현황"].append("DNS 서비스가 실행 중이지 않습니다.")

    except subprocess.CalledProcessError as e:
        results["진단 결과"] = "오류"
        results["현황"].append(f"DNS 서비스 실행 확인 중 오류 발생: {e}")

    return results

def main():
    results = check_dns_zone_transfer_settings()
    print(json.dumps(results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
