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

rsh_status=$(service is-active rsh.socket)
rlogin_status=$(service is-active rlogin.socket)
rexec_status=$(service is-active rexec.socket)

if [ "$rsh_status" == "active" ] && [ "$rlogin_status" == "active" ] && [ "$rexec_status" == "active" ]; then
  WARN "rsh, rlogin 및 exec 서비스가 실행 중"
else
  OK "하나 이상의 rsh, rlogin 및 exec 서비스가 실행되고 있지 않습니다."
fi

cat $result

echo ; echo