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

# PASS_MAX_DA의 값을 가져옵니다
pass_max_days=$(grep "^PASS_MAX_DAYS" /etc/login.defs | awk '{print $2}')

# 값이 90보다 작거나 같은지 확인합니다
if [ $pass_max_days -le 90 ]; then
  OK "PASS_MAX_DAYS가 90 이하인 $pass_max_days 로 설정되었습니다."
else
  WARN "PASS_MAX_DAYS가 90보다 큰 $pass_max_days 로 설정되었습니다."
fi

 

 

cat $result

echo ; echo
