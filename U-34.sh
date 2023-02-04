#!/bin/bash

 

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



# 서비스가 실행 중인지 확인합니다
if systemctl is-active --quiet named; then
  WARN "DNS 서비스가 실행 중입니다"
else
  OK "DNS 서비스가 실행되고 있지 않습니다"
fi

# /etc/bind/name.conf에 전송 허용 설정이 있는지 확인하십시오
if grep -q "allow-transfer" /etc/bind/named.conf; then
  OK "allow-transfer 설정이 /etc/bind/name.conf에 있습니다"
else
  WARN "allow-transfer 설정이 /etc/bind/name.conf에 없습니다"
fi

# xfrnets 설정이 /etc/bind/name.conf에 있는지 확인합니다
if grep -q "xfrnets" /etc/bind/named.conf; then
  OK "xfrnets 설정이 /etc/bind/name.conf에 있습니다"
else
  WARN "xfrnets 설정이 /etc/bind/name.conf에 없습니다"
fi




cat $result

echo ; echo