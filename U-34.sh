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

# Check if the DNS service is running
if ! systemctl is-active --quiet named; then
  echo "Error: DNS service (named)가 실행되고 있지 않습니다."
fi

# Check if zone transfers are allowed for any hosts
if ! grep -q "allow-transfer" /etc/named.conf; then
  echo "Error: Zone transfers가 어떤 호스트에도 허용되지 않습니다."
fi

# Check if zone transfers are allowed for all hosts
if ! grep -q "allow-transfer { any; };" /etc/named.conf; then
  echo "Error: Zone transfers가 일부 호스트에 대해 영역 전송이 허용되지 않음"
fi

# If the script reaches this point, zone transfers are allowed for all hosts
echo "모든 호스트에 대해 영역 전송이 허용됨"



cat $result

echo ; echo