#!/bin/bash

 

. function.sh

 

BAR

CODE [U-67] SNMP 서비스 Community String의 복잡성 설정

cat << EOF >> $U67

[양호]: SNMP Community 이름이 public, private 이 아닌 경우

[취약]: SNMP Community 이름이 public, private 인 경우

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

cat $U67

echo ; echo 
