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

# Get the value of PASS_MIN_LEN from the login.defs file
pass_min_len=$(grep -E "^PASS_MIN_LEN" /etc/login.defs | awk '{print $2}')

# Check if the value is greater than or equal to 8
if [ $pass_min_len -ge 8 ]; then
  echo "PASS_MIN_LEN is set to $pass_min_len which is greater than or equal to 8"
else
  echo "PASS_MIN_LEN is set to $pass_min_len which is less than 8"
fi

 

cat $result

echo ; echo
