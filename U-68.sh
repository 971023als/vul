#!/bin/bash

 

. function.sh

 

BAR

CODE [U-68] 로그온 시 경고 메시지 제공

cat << EOF >> $RESULT

[양호]: 서버 및 Telnet 서비스에 로그온 메시지가 설정되어 있는 경우

[취약]: 서버 및 Telnet 서비스에 로그온 메시지가 설정되어 있지 않은 경우

EOF

BAR

 

# Set the path of the SNMP configuration file
snmp_conf_file="/etc/snmp/snmpd.conf"

# Check if the SNMP configuration file exists
if [ ! -f $snmp_conf_file ]; then
    INFO "SNMP 구성 파일이 없습니다."
else
    # Check if the community name is public or private
    if grep -q "public" $snmp_conf_file; then
        WARN "SNMP 커뮤니티 이름이 공개됨"
    elif grep -q "private" $snmp_conf_file; then
        WARN "SNMP 커뮤니티 이름은 비공개입니다"
    else
        OK "SNMP 커뮤니티 이름이 공개 또는 비공개가 아닙니다"
    fi
fi

cat $RESULT

echo ; echo 

 
