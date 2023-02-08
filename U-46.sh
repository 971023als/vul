#!/bin/bash

 

. function.sh

TMP1=`SCRIPTNAME`.log

> $TMP1 

BAR

CODE [U-46] 패스워드 최소 길이 설정

cat << EOF >> $result

[양호]: 패스워드 최소 길이가 8자 이상으로 설정되어 있는 경우

[취약]: 패스워드 최소 길이가 8자 미만으로 설정되어 있는 경우

EOF

BAR

TMP1=`SCRIPTNAME`.log

> $TMP1

# login.defs 파일에서 PASS_MIN_LEN 값을 가져옵니다
pass_min_len=$(grep -E "^PASS_MIN_LEN" /etc/login.defs | awk '{print $2}')

# 값이 8보다 크거나 같은지 점검하십시오
if grep -q "^#PASS_MIN_LEN" /etc/login.defs; then
  WARN "PASS_MIN_LEN이 주석 처리되었습니다."
else
  if [ $pass_min_len -ge 8 ]; then
    OK "PASS_MIN_LEN이 8보다 크거나 같은 $pass_min_len 으로 설정됨"
  else
    WARN "PASS_MIN_LEN이 8보다 작은 $pass_min_len 으로 설정됨"
  fi
fi


 

cat $result

echo ; echo
