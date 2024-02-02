#!/usr/bin/python3
import subprocess
import re

def check_snmp_community_string_complexity():
    results = {
        "분류": "서비스 관리",
        "코드": "U-67",
        "위험도": "중",
        "진단 항목": "SNMP 서비스 Community String의 복잡성 설정",
        "진단 결과": "양호",  # Assume "Good" until proven otherwise
        "현황": "SNMP Community String이 적절히 설정되어 있습니다.",
        "대응방안": "SNMP Community 이름이 public, private이 아닌 경우"
    }

    # Check if SNMP service is running
    ps_output = subprocess.run(['ps', '-ef'], stdout=subprocess.PIPE, text=True).stdout
    if 'snmp' not in ps_output.lower():
        return results  # SNMP service is not running, no need to check further

    # Search for snmpd.conf files
    find_command = ['find', '/', '-name', 'snmpd.conf', '-type', 'f']
    find_result = subprocess.run(find_command, stdout=subprocess.PIPE, text=True, stderr=subprocess.DEVNULL)
    snmpdconf_files = find_result.stdout.strip().split('\n')

    if not snmpdconf_files or snmpdconf_files == ['']:
        results["진단 결과"] = "취약"
        results["현황"] = "SNMP 서비스를 사용하고, Community String을 설정하는 파일이 없습니다."
        return results

    # Check for weak community strings in snmpd.conf files
    for file_path in snmpdconf_files:
        try:
            with open(file_path, 'r') as file:
                file_content = file.read()
                if re.search(r'public|private', file_content, re.IGNORECASE):
                    results["진단 결과"] = "취약"
                    results["현황"] = f"SNMP Community String이 public 또는 private으로 설정되어 있습니다. 파일: {file_path}"
                    return results
        except Exception as e:
            # Handle exceptions, such as permission issues, by skipping the file or logging an error
            continue

    return results

def main():
    snmp_community_string_complexity_check_results = check_snmp_community_string_complexity()
    print(snmp_community_string_complexity_check_results)

if __name__ == "__main__":
    main()
