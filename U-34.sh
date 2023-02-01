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

# DNS service (named)가 실행 확인
if ! systemctl is-active --quiet named; then
  WARN "DNS service (named)가 실행되고 있지 않습니다."
fi

# Zone transfers 호스트 확인
if ! grep -q "allow-transfer" /etc/named.conf; then
  WARN "Zone transfers가 어떤 호스트에도 허용되지 않습니다."
fi

# Zone transfers가 일부 호스트에 대해 영역 전송 확인
if ! grep -q "allow-transfer { any; };" /etc/named.conf; then
  WARN "Zone transfers가 일부 호스트에 대해 영역 전송이 허용되지 않음"
fi

# 스크립트가 이 지점에 도달하면 소유권 및 사용 권한이 올바른 것입니다
OK "모든 호스트에 대해 영역 전송이 허용됨"



cat $result

echo ; echo