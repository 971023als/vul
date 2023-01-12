#!/bin/bash

 

. function.sh

TMP1=`SCRIPTNAME`.log

> $TMP1  

BAR

CODE [U-33]  DNS 보안 버전 패치 '확인 필요'

cat << EOF >> $result

[양호]: DNS 서비스를 사용하지 않거나 주기적으로 패치를 관리하고 있는 경우

[취약]: DNS 서비스를 사용하며 주기적으로 패치를 관리하고 있지 않는 경우


EOF

BAR

# Check if DNS service is running
result=`systemctl is-active bind9`
if [[ $result == "active" ]]; then
  echo "DNS 서비스가 실행 중"
else
  echo "DNS 서비스가 실행되고 있지 않습니다."
fi

# Check if DNS service is being patched regularly
result=$(find /var/log/apt/ -name '*.log' -type f -mtime -30 | grep "bind9")
if [[ -n "$result" ]]; then
  echo "DNS 서비스가 정기적으로 패치되고 있습니다."
else
  echo "DNS 서비스가 정기적으로 패치되지 않고 있습니다."
fi



cat $result

echo ; echo