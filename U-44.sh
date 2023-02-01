#!/bin/bash

 

. function.sh

TMP1=`SCRIPTNAME`.log

> $TMP1

 

BAR

CODE [U-44] root 이외의 UID가 '0' 금지

cat << EOF >> $result

[양호]: root 계정과 동일한 UID를 갖는 계정이 존재하지 않는 경우

[취약]: root 계정과 동일한 UID를 갖는 계정이 존재하는 경우

EOF

BAR


# 루트 계정의 UID 가져오기
root_uid=$(id -u root)

# 루트 계정과 동일한 UID를 가진 계정 검색
matching_accounts=$(awk -F: -v uid="$root_uid" '$3 == uid { print $1 }' /etc/passwd)

# 발견된 계정이 있는지 확인하십시오
if [ -n "$matching_accounts" ]; then
  WARN "UID가 $root_uid인 계정이 발견되었습니다"
fi

# 스크립트가 이 지점에 도달하면 계정을 찾을 수 없습니다
OK "UID $root_uid를 가진 계정을 찾을 수 없습니다."
 


 

cat $result

echo ; echo
