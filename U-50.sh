#!/bin/bash

 

. function.sh

TMP1=`SCRIPTNAME`.log

> $TMP1

TMP2=$(mktemp)

 

BAR

CODE [U-50] 관리자 그룹에 최소한의 계정 포함

cat << EOF >> $result

양호: 관리자 그룹에 불필요한 계정이 등록되어 있지 않은 경우

취약: 관리자 그룹에 불필요한 계정이 등록되어 있는 경우

EOF

BAR

# Define a list of necessary accounts
necessary_accounts=("root" "Administrator" "ubuntu" "user")

# Search for accounts that are not in the list of necessary accounts
unnecessary_accounts=$(getent group Administrators | awk -F: '{split($4,a,","); for(i in a) {if (!(a[i] in necessary_accounts)) { print a[i] }}}')

# Check if any unnecessary accounts were found
if [ -n "$unnecessary_accounts" ]; then
  WARN "Error: Administrators 그룹에서 불필요한 계정이 발견되었습니다.: $unnecessary_accounts"
fi

# If the script reaches this point, no unnecessary accounts were found in the Administrators group
OK "Administrators 그룹에서 불필요한 계정을 찾을 수 없습니다."
 



 

cat $result

echo ; echo
