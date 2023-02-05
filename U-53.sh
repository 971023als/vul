#!/bin/bash

 

. function.sh

 

TMP1=`SCRIPTNAME`.log

> $TMP1

TMP2=/tmp/tmp1

> $TMP2

 

BAR

CODE [U-53] 사용자 shell 점검

cat << EOF >> $result

[양호]: 로그인이 필요하지 않은 계정에 /bin/false(nologin) 쉘이 부여되지 않은 경우

[취약]: 로그인이 필요하지 않은 계정에 /bin/false(nologin) 쉘이 부여되어 있는 경우

EOF

BAR

 


# 로그인이 필요 없는 계정 목록 가져오기
nologin_accounts=$(grep -E 'nologin$|false$' /etc/passwd | awk -F: '{print $1}')

# 로그인이 필요하지 않은 계정에 로그인 셸이 부여되지 않았는지 확인합니다
for account in $nologin_accounts; do
  shell=$(grep "^$account:" /etc/passwd | awk -F: '{print $NF}')
  if [[ "$shell" != "/sbin/nologin" && "$shell" != "/bin/false" ]]; then
    WARN " 로그인이 필요 없는 계정 $account가 로그인 셸을 사용하지 않습니다. 현재 $shell 사용 중"
  fi
done

# 스크립트가 이 지점에 도달하면 로그인이 필요하지 않은 모든 계정이 로그인 셸을 사용하는 것입니다
OK "로그인이 필요하지 않은 모든 계정은 nologin 셸을 사용하고 있습니다."


 

cat $result

echo ; echo
