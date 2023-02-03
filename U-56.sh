#!/bin/bash

 

. function.sh


TMP1=`SCRIPTNAME`.log

> $TMP1 

 

BAR

CODE [U-56] UMASK 설정 관리 

cat << EOF >> $result

[양호]: UMASK 값이 022 이하로 설정된 경우

[취약]: UMASK 값이 022 이하로 설정되지 않은 경우 

EOF

BAR


if grep -q "umask 022" /etc/profile; then
  OK "umask 022가 /etc/profile에 있습니다."
else
  WARN "umask 022가 /etc/profile에 없습니다."
fi


cat $result

echo ; echo 

 
