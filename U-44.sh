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

# 루트 계정 UID
root_uid=0

# 루트와 동일한 UID를 가진 계정이 있는지 확인하십시오
accounts_with_root_uid=$(grep ":$root_uid:" /etc/passwd | cut -d: -f1)

# 루트와 동일한 UID를 가진 계정이 있는지 확인하십시오
if [ -z "$accounts_with_root_uid" ]; then
  OK "루트 계정과 동일한 UID를 가진 계정이 없습니다."
else
  WARN "다음 계정의 UID가 루트 계정과 동일합니다."
  INFO $accounts_with_root_uid
fi



 

cat $result

echo ; echo
