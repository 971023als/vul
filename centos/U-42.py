#!/usr/bin/python3
import subprocess
import json

def get_version(command):
    try:
        version = subprocess.check_output(command, shell=True).decode('utf-8').strip()
        return version
    except subprocess.CalledProcessError:
        return "버전 정보를 가져올 수 없음"

def check_security_patches():
    services = {
        "Apache": "apache2 -v",
        "MySQL": "mysql --version",
        "PHP": "php -v",
        "Nginx": "nginx -v",
        "Node.js": "node -v",
        "MariaDB": "mariadb --version",
        "PostgreSQL": "postgres --version",
        "Oracle": "sqlplus -v"
    }
    
    results = {
        "분류": "패치 관리",
        "코드": "U-42",
        "위험도": "상",
        "진단 항목": "최신 보안패치 및 벤더 권고사항 적용",
        "진단 결과": [],
        "대응방안": "패치 적용 정책 수립 및 주기적 패치 관리"
    }

    for service, command in services.items():
        version = get_version(command)
        results["진단 결과"].append({
            "서비스": service,
            "현재 버전": version,
            "패치 적용 여부": "N/A",  # 실제 패치 적용 여부 점검 로직 필요
            "비고": "자동 점검 결과"
        })

    return results

def main():
    patch_check_results = check_security_patches()
    print(json.dumps(patch_check_results, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    main()
