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

# 암호 최소 사용 기간 가져오기
min_age=$(grep -i "^password.*minimum.*age" /etc/login.defs | awk '{print $NF}')

# min_age 변수가 비어 있는지 확인합니다
if [ -z "$min_age" ]; then
  WARN "암호 최소 사용 기간이 설정되지 않았습니다"
fi

# 스크립트가 이 지점에 도달하면 암호 최소 사용 기간이 설정됩니다
OK "암호 최소 사용 기간이 설정됨"


 

cat $result

echo ; echo
