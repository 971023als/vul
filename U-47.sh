#!/bin/bash

 

. function.sh


TMP1=`SCRIPTNAME`.log

> $TMP1  

BAR

CODE [U-47] 패스워드 최대 사용기간 설정

cat << EOF >> $result

[양호]: 패스워드 최대 사용기간이 90일(12주) 이하로 설정되어 있는 경우

[취약]: 패스워드 최대 사용기간이 90일(12주) 이하로 설정되어 있지 않은 경우

EOF

BAR

PASS_MAX_DAYS=$(grep "^PASS_MAX_DAYS" /etc/login.defs | awk '{print $2}')

if [ -z "$PASS_MAX_DAYS" ]; then
  WARN "PASS_MAX_DAYS가 /etc/login.defs에 설정되어 있지 않습니다."
else
  if [ "$PASS_MAX_DAYS" -le 90 ]; then
    OK "PASS_MAX_DAYS가 $PASS_MAX_DAYS로 설정되어 있으며, 이는 90보다 작거나 같습니다."
  else
    WARN "PASS_MAX_DAYS가 90보다 큰 $PASS_MAX_DAYS로 설정되었습니다."
  fi
fi

 

 

cat $result

echo ; echo
