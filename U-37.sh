#!/bin/bash

 

. function.sh

 
TMP1=`SCRIPTNAME`.log

> $TMP1 
 

BAR

CODE [U-37] Apache 상위 디렉터리 접근 금지 

cat << EOF >> $result

[양호]: 상위 디렉터리에 이동제한을 설정한 경우

[취약]: 상위 디렉터리에 이동제한을 설정하지 않은 경우

EOF

BAR

# 인증 파일 경로 정의
auth_file="/path/to/authentication_file"

# 사용자 이름 정의
username="user"

# 인증 파일에 사용자 이름이 있는지 확인합니다
if htpasswd -D $auth_file $username &> /dev/null; then
  echo "사용자 $username 은 이미 존재합니다"
else
  echo "사용자 $username 생성"
  htpasswd -c $auth_file $username
fi



cat $result

echo ; echo

 

 

