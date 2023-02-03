#!/bin/bash

 

. function.sh

TMP1=`SCRIPTNAME`.log

> $TMP1

 

BAR

CODE [U-48] 패스워드 최소 사용기간 설정

cat << EOF >> $result

[양호]: 패스워드 최소 사용기간이 1일(1주)로 설정되어 있는 경우

[취약]: 패스워드 최소 사용기간이 설정되어 있지 않는 경우

EOF

BAR

if grep -q "PASS_MIN_DAYS" /etc/login.defs; then
  OK "PASS_MIN_DAYS가 /etc/login.defs에 있습니다."
else
  WARN "PASS_MIN_DAYS가 /etc/login.defs에 없습니다."
fi


 

cat $result

echo ; echo
