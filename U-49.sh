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



# 필요한 계정 목록 정의
necessary_accounts=("root" "bin" "daemon" "adm" "lp" "sync" "shutdown" "halt" "ubuntu" "user")

# 필요한 계정 목록에 없는 계정 검색
unnecessary_accounts=$(awk -F: '{if (!($1 in necessary_accounts)) { print $1 }}' /etc/passwd)

# 불필요한 계정이 발견되었는지 확인합니다
if [ -n "$unnecessary_accounts" ]; then
  WARN " 불필요한 계정이 발견되었습니다. $insequired_accounts"
fi

# 스크립트가 이 지점에 도달하면 불필요한 계정을 찾을 수 없습니다
OK "불필요한 계정을 찾을 수 없습니다."


 

 

cat $result

echo ; echo
