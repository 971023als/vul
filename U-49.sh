#!/bin/bash

 

. function.sh

 

TMP1=`SCRIPTNAME`.log

> $TMP1

 

 

BAR

CODE [U-49] 불필요한 계정 제거

cat << EOF >> $result

[양호]: 불필요한 계정이 존재하지 않는 경우

[취약]: 불필요한 계정이 존재하는 경우

EOF

BAR



# Define a list of necessary accounts
necessary_accounts=("root" "bin" "daemon" "adm" "lp" "sync" "shutdown" "halt" "ubuntu" "user")

# Search for accounts that are not in the list of necessary accounts
unnecessary_accounts=$(awk -F: '{if (!($1 in necessary_accounts)) { print $1 }}' /etc/passwd)

# Check if any unnecessary accounts were found
if [ -n "$unnecessary_accounts" ]; then
  WARN "Error: 불필요한 계정이 발견되었습니다. $insequired_accounts"
fi

# If the script reaches this point, no unnecessary accounts were found
OK "불필요한 계정을 찾을 수 없습니다."


 

 

cat $result

echo ; echo
