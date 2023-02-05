#!/bin/bash

. function.sh


TMP1=`SCRIPTNAME`.log

> $TMP1

BAR

CODE [U-45] root 계정 su 제한

cat << EOF >> $result

[양호]: su 명령어를 특정 그룹에 속한 사용자만 사용하도록 제한되어 있는 경우

[취약]: su 명령어를 모든 사용자가 사용하도록 설정되어 있는 경우

EOF

BAR


# 모든 사용자에 대해 su 명령이 활성화되었는지 확인합니다
if [ $(grep -c '^SU_WHEEL_ONLY' /etc/login.defs) -eq 0 ]; then
  WARN "su 명령은 모든 사용자에 대해 활성화됩니다."
else
  wheel_group=$(grep '^SU_WHEEL_GROUP' /etc/login.defs | cut -d' ' -f2)
  OK "su 명령은 $wheel_group 그룹의 멤버로 제한됩니다."
fi

 

cat $result

echo ; echo
