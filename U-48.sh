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

# /etc/login.defs에서 PASS_MIN_DAYS 값을 읽습니다
pass_min_days=$(grep "^PASS_MIN_DAYS" /etc/login.defs | awk '{print $2}')

if grep -q "^#PASS_MIN_DAYS" /etc/login.defs; then
  WARN "PASS_MIN_DAYS이 주석 처리되었습니다."
  # PASS_MIN_DAYS 값이 7 이상인지 확인합니다
  if [ "$pass_min_len" -ge 0 ] && [ "$pass_min_len" -le 99999999 ]; then
    if [ "$pass_min_days" -ge 7 ]; then
      OK "PASS_MIN_DAYS가 /etc/login.defs에 있습니다."
    else
      WARN "PASS_MIN_DAYS가 /etc/login.defs에 없습니다."
    fi
  else
    INFO "PASS_MIN_DAYS 값이 숫자가 아닙니다."
  fi
fi 

 

cat $result

echo ; echo
