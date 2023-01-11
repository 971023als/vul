#!/bin/bash

. function.sh

TMP1=`SCRIPTNAME`.log

> $TMP1

BAR
CODE [U-23] DoS 공격에 취약한 서비스 비활성화

cat << EOF >> $TMP1
[ 양호 ] : DoS 공격에 취약한 echo, discard, daytime, chargen 서비스가 비활성화 된 경우
[ 취약 ] : DoS 공격에 취약한 echo, discard, daytime, chargen 서비스 활성화 된 경우
EOF
BAR


services=( "echo" "discard" "daytime" "chargen" "ntp" "snmp" )

for service in "${services[@]}"
do
    if systemctl is-active --quiet "$service"; then
        WARN "$service 가 DoS 공격에 취약한 서비스가 실행 중입니다"
    else
        OK "$service 가 DoS 공격에 취약한 서비스가 실행되고 있지 않습니다"
    fi
done

cat $TMP1

echo ; echo