#!/bin/bash

 

. function.sh

 
TMP1=`SCRIPTNAME`.log

> $TMP1
 

BAR

CODE [U-31] 스팸 메일 릴레이 제한

cat << EOF >> $result

[양호]: SMTP 서비스를 사용하지 않거나 릴레이 제한이 설정되어 있는 경우

[취약]: SMTP 서비스를 사용하며 릴레이 제한이 설정되어 있지 않은 경우

EOF

BAR


# snmp 서비스가 활성 상태인지 확인합니다
if systemctl is-active --quiet snmpd; then
    WARN "SNMP 서비스가 활성되어 있습니다"
else
    OK "SNMP 서비스가 활성화되지 않았습니다."
fi

cat $result

echo ; echo
 
