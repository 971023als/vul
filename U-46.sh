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


min_len=$(grep "^PASS_MIN_LEN" /etc/login.defs | awk '{print $2}')

if [ "$min_len" -lt "8" ]; then
  WARN "암호 최소 길이가 8자 미만으로 설정되었습니다."
else
  OK "암호 최소 길이가 8자 이상으로 설정되었습니다."
fi


 

cat $result

echo ; echo
