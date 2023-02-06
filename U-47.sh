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

# 값이 90보다 작거나 같은지 확인합니다
if [ $pass_max_days -le 90 ]; then
  echo "PASS_MAX_DAYS가 90보다 작거나 같은 $pass_max_days로 설정됨"
else
  echo "PASS_MAX_DAYS가 90보다 큰 $pass_max_days로 설정됨"
fi
 

 

cat $result

echo ; echo
