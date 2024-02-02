#!/usr/bin/python3
import subprocess
import re

def check_ftp_service():
    results = {
        "분류": "서비스 관리",
        "코드": "U-61",
        "위험도": "하",
        "진단 항목": "ftp 서비스 확인",
        "진단 결과": "양호",  # Assume "Good" until proven otherwise
        "현황": [],
        "대응방안": "FTP 서비스가 비활성화 되어 있는 경우"
    }

    # Check for FTP service in /etc/services
    try:
        with open('/etc/services', 'r') as file:
            services_content = file.read()
            ftp_ports = re.findall(r'^ftp\s+(\d+)/tcp', services_content, re.MULTILINE)
            if ftp_ports:
                results["현황"].append(f"FTP 포트가 /etc/services에 설정됨: {', '.join(ftp_ports)}")
                results["진단 결과"] = "취약"
    except FileNotFoundError:
        results["현황"].append("/etc/services 파일을 찾을 수 없습니다.")

    # Check for running FTP services
    netstat_output = subprocess.run(['netstat', '-tuln'], stdout=subprocess.PIPE, text=True).stdout
    if any(port in netstat_output for port in ftp_ports):
        results["현황"].append("FTP 서비스가 실행 중입니다.")
        results["진단 결과"] = "취약"

    # Check for vsftpd and proftpd configuration files
    for ftp_conf in ['vsftpd.conf', 'proftpd.conf']:
        find_conf = subprocess.run(['find', '/', '-name', ftp_conf], stdout=subprocess.PIPE, text=True).stdout.splitlines()
        if find_conf:
            results["현황"].append(f"{ftp_conf} 파일이 시스템에 존재합니다.")
            results["진단 결과"] = "취약"

    # Process check for common FTP services
    ps_output = subprocess.run(['ps', '-ef'], stdout=subprocess.PIPE, text=True).stdout
    if re.search(r'ftpd|vsftpd|proftpd', ps_output, re.IGNORECASE):
        results["현황"].append("FTP 관련 프로세스가 실행 중입니다.")
        results["진단 결과"] = "취약"

    return results

def main():
    ftp_check_results = check_ftp_service()
    print(ftp_check_results)

if __name__ == "__main__":
    main()
