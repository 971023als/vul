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

# login.defs 파일에서 PASS_MAX_DAYS 값을 가져옵니다
pass_max_days=$(grep -E "^PASS_MAX_DAYS" /etc/login.defs | awk '{print $2}')

max=90

# 값이 90보다 작거나 같은지 확인합니다
if grep -q "^PASS_MAX_DAYS" /etc/login.defs; then
  WARN "PASS_MAX_DAYS이 주석 처리되었습니다."
else
  if ! [[ $pass_max_days =~ ^[0-9]+$ ]]; then
    INFO "PASS_MAX_DAYS 값이 숫자가 아닙니다."
  else
    if [ $pass_max_days -le $max ]; then
      OK "PASS_MAX_DAYS가 90 이하인 $pass_max_days 로 설정되었습니다."
    else
      WARN "PASS_MAX_DAYS가 90보다 큰 $pass_max_days 로 설정되었습니다."
    fi
  fi
fi

 

 

cat $result

echo ; echo
