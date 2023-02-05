#!/bin/bash

 

. function.sh

 

TMP1=`SCRIPTNAME`.log

> $TMP1

 

BAR

CODE [U-54] Session Timeout 설정

cat << EOF >> $result

[양호]: Session Timeout이 600초(10분) 이하로 설정되어 있는 경우

[취약]: Session Timeout이 600초(10분) 이하로 설정되지 않은 경우

EOF

BAR

# check if TMOUT is set to 600 in /etc/profile
if grep -q "TMOUT=600" /etc/profile; then
  echo "TMOUT is set to 600 in /etc/profile"
else
  echo "TMOUT is not set to 600 in /etc/profile"
fi



cat $result

echo ; echo
