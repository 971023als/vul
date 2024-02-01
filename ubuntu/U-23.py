#!/usr/bin/python3

import glob
import subprocess

def check_service_status(service_name):
    service_files = glob.glob(f'/etc/xinetd.d/{service_name}*')
    if not service_files:
        print(f"OK /etc/xinetd.d/{service_name} 파일이 존재하지 않습니다.")
        return
    
    for service_file in service_files:
        print(f"INFO {service_file} 파일이 존재합니다.")
        with open(service_file, 'r') as file:
            content = file.read()
            if 'disable         = yes' in content:
                print(f"OK {service_file} 파일에 대한 서비스가 비활성화 되어 있습니다.")
            else:
                print(f"WARN {service_file} 파일에 대한 서비스가 활성화 되어 있습니다.")

def main():
    print("CODE [U-23] DoS 공격에 취약한 서비스 비활성화")
    print("[ 양호 ] : DoS 공격에 취약한 echo, discard, daytime, chargen 서비스가 비활성화 된 경우")
    print("[ 취약 ] : DoS 공격에 취약한 echo, discard, daytime, chargen 서비스 활성화 된 경우")

    services = ['echo', 'discard', 'daytime', 'chargen']
    for service in services:
        check_service_status(service)

if __name__ == "__main__":
    main()
