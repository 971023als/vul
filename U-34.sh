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



# DNS 서비스가 실행 중인지 확인합니다
dns_status=$(systemctl is-active named)

if [ "$dns_status" == "active" ]; then
  INFO "DNS 쿼리 확인 중"
  queries=$(ss -u | grep named | wc -l)
  if [ $queries -eq 0 ]; then
    OK "DNS 쿼리가 검색되지 않음, 명명된 서비스 중지"
    systemctl stop named
  else
    INFO "DNS 쿼리가 탐지됨, 명명된 서비스가 계속 실행됨"
  fi
else
  OK "DNS 서비스가 이미 중지되었습니다."
fi




cat $result

echo ; echo