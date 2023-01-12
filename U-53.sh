#!/bin/bash

 

. function.sh

 

TMP1=`SCRIPTNAME`.log

> $TMP1

TMP2=/tmp/tmp1

> $TMP2

 

BAR

CODE [U-53] 사용자 shell 점검

cat << EOF >> $result

[취약]: 로그인이 필요하지 않은 계정에 /bin/false(nologin) 쉘이 부여되어 있는 경우

[양호]: 로그인이 필요하지 않은 계정에 /bin/false(nologin) 쉘이 부여되지 않은 경우

EOF

BAR

 


# Get a list of accounts that do not require login
nologin_accounts=$(grep -E 'nologin$|false$' /etc/passwd | awk -F: '{print $1}')

# Check if any accounts that do not require login were not granted a nologin shell
for account in $nologin_accounts; do
  shell=$(grep "^$account:" /etc/passwd | awk -F: '{print $NF}')
  if [[ "$shell" != "/sbin/nologin" && "$shell" != "/bin/false" ]]; then
    WARN "Error: 로그인이 필요 없는 계정 $account가 로그인 셸을 사용하지 않습니다. 현재 $shell 사용 중"
  fi
done

# If the script reaches this point, all accounts that do not require login are using a nologin shell
OK "로그인이 필요하지 않은 모든 계정은 nologin 셸을 사용하고 있습니다."


 

cat $result

echo ; echo
