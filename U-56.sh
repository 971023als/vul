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

# check if UMASK is set to 022 in /etc/profile
if grep -q "UMASK=022" /etc/profile; then
  echo "UMASK is set to 022 in /etc/profile"
else
  echo "UMASK is not set to 022 in /etc/profile"
fi



cat $result

echo ; echo 

 
