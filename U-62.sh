#!/bin/bash

 

. function.sh

 
TMP1=`SCRIPTNAME`.log

> $TMP1 
 

BAR

CODE [U-62] ftp 계정 shell 제한

cat << EOF >> $result

[양호]: ftp 계정에 /bin/false 쉘이 부여되어 있는 경우

[취약]: ftp 계정에 /bin/false 쉘이 부여되지 않 경우

EOF

BAR



# 명령을 사용하여 모든 ftp 계정 가져오기 
ftp_users=$(getent passwd | grep -E "^ftp" | cut -d: -f1)

# 각 ftp 계정을 반복합니다
for user in $ftp_users; do
  #  ftp 계정의 셸을 가져옵니다
  shell=$(getent passwd $user | cut -d: -f7)

  # ftp 계정에 /bin/false 셸이 있는지 확인합니다
  if [ "$shell" != "/bin/false" ]; then
    OK "ftp 계정 $user에 /bin/false 셸이 없습니다"
  else
    WARN "ftp 계정 $user에 /bin/false 셸이 있습니다."
  fi



cat $result

echo ; echo 

 
