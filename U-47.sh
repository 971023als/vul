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

# 암호 최대 사용 기간이 90일로 설정되었는지 확인합니다
if [ $(grep -c '^PASS_MAX_DAYS\s*90' /etc/login.defs) -eq 1 ]; then
  OK "암호 최대 사용 기간은 예상대로 90일로 설정됩니다."
else
  WARN "암호 최대 사용 기간이 90일로 설정되지 않았습니다."
fi

 

 

cat $result

echo ; echo
