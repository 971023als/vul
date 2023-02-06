#!/bin/bash

 

. function.sh

 

TMP1=`SCRIPTNAME`.log

> $TMP1

TMP2=/tmp/tmp2

> $TMP2

 

BAR

CODE [U-21] r 계열 서비스 비활성화

cat << EOF >> $result

[양호]: r 계열 서비스가 비활성화 되어 있는 경우

[취약]: r 계열 서비스가 활성화 되어 있는 경우

EOF

BAR

services=$(ls -alL /etc/xinetd.d/* | egrep "rsh|rlogin|rexec" | egrep -v "grep|klogin|kshell|kexec")

if [ -z "$services" ]; then
  OK "rsh, rlogin 및 exec 서비스가 실행되고 있지 않습니다."
else
  WARN "하나 이상의 rsh, rlogin 및 exec 서비스가 실행 중"
fi


cat $result

echo ; echo