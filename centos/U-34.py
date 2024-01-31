#!/bin/python3
 

. function.sh

TMP1=`SCRIPTNAME`.log

> $TMP1   

 

BAR

CODE [U-34] DNS Zone Transfer 설정

cat << EOF >> $result

[양호]: DNS 서비스 미사용 또는, Zone Transfer를 허가된 사용자에게만 허용한 경우

[취약]: DNS 서비스를 사용하여 Zone Transfer를 모든 사용자에게 허용한 경우

EOF

BAR

# DNS 프로세스가 지금 실행 중인지 확인합니다
dns_process=$(ps -ef | grep named | grep -v grep)

# DNS 프로세스가 계속 실행되면 오류 메시지를 인쇄합니다
if [ -z "$dns_process" ]; then
  OK "DNS 서비스 데몬이 실행되고 있지 않습니다."
else
  WARN "DNS 서비스 데몬이 실행 중입니다."
fi


cat $result

echo ; echo

if nonexistent_device_files:
        results.append({
            "분류": "서비스 관리",
            "코드": "U-34",
            "위험도": "상",
            "진단 항목": "DNS Zone Transfer 설정",
            "진단 결과": "취약",
            "현황": "DNS(named) 데몬이 활성화 되어 있는 상태",
            "대응방안": "DNS(named) 데몬 비활성화"
        })
    else:
        results.append({
            "분류": "서비스 관리",
            "코드": "U-34",
            "위험도": "상",
            "진단 항목": "DNS Zone Transfer 설정",
            "진단 결과": "양호",
            "현황": "DNS(named) 데몬이 비활성화 되어 있는 상태",
            "대응방안": "DNS(named) 데몬 비활성화"
        })

return results