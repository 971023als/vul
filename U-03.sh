#!/bin/bash

 

. function.sh

TMP1=`SCRIPTNAME`.log

> $TMP1

 

BAR

CODE [U-03] 계정 잠금 임계값 설정

cat << EOF >> $result

[양호]: 계정 잠금 임계값이 10회 이하의 값으로 설정되어 있는 경우

[취약]: 계정 잠금 임계값이 설정되어 있지 않거나, 10회 이하의 값으로 설정되지 않은 경우

EOF

BAR

# 파일에 올바른 줄이 있는지 확인합니다
if grep -q "auth required /lib/security/pam_tally.so deny=5 unlock_time=120 no_magic_root" /etc/pam.d/common-auth; then
  # 올바른 옵션이 설정되어 있는지 확인하십시오
  if grep -q "deny=5" /etc/pam.d/common-auth && grep -q "unlock_time=120" /etc/pam.d/common-auth && grep -q "no_magic_root" /etc/pam.d/common-auth; then
    OK "/etc/pam.d/common-auth에서 올바른 설정이 설정되었습니다."
  else
    WARN "/etc/pam.d/common-auth에서 올바른 옵션이 설정되지 않았습니다."
  fi
else
  WARN "/etc/pam.d/common-auth에서 올바른 행을 찾을 수 없습니다."
fi


cat $result

echo ; echo
