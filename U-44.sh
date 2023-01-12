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


# Get the UID of the root account
root_uid=$(id -u root)

# Search for accounts with the same UID as the root account
matching_accounts=$(awk -F: -v uid="$root_uid" '$3 == uid { print $1 }' /etc/passwd)

# Check if any accounts were found
if [ -n "$matching_accounts" ]; then
  WARN "Error: UID가 $root_uid인 계정이 발견되었습니다"
fi

# If the script reaches this point, no accounts were found
OK "UID $root_uid를 가진 계정을 찾을 수 없습니다."
 


 

cat $result

echo ; echo
