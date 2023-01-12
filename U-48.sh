#!/bin/bash

 

. function.sh

TMP1=`SCRIPTNAME`.log

> $TMP1

 

BAR

CODE [U-48] 패스워드 최소 사용기간 설정

cat << EOF >> $result

[양호]: 패스워드 최소 사용기간이 1일(1주)로 설정되어 있는 경우

[취약]: 패스워드 최소 사용기간이 설정되어 있지 않는 경우

EOF

BAR

# Get the password minimum age
min_age=$(grep -i "^password.*minimum.*age" /etc/login.defs | awk '{print $NF}')

# check if the variable min_age is empty
if [ -z "$min_age" ]; then
  WARN "Error: 암호 최소 사용 기간이 설정되지 않았습니다"
fi

# If the script reaches this point, the password minimum age is set
OK "암호 최소 사용 기간이 설정됨"


 

cat $result

echo ; echo
