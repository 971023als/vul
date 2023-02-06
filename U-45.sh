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

# su 명령에 액세스할 수 있어야 하는 그룹의 이름
group="wheel"

# 그룹이 있는지 확인하십시오
if grep -q "^$group:" /etc/group; then
  OK "그룹 $group 이 존재합니다"
else
  WARN "그룹 $group 이 존재하지 않습니다"
fi

# su에 대한 PAM 모듈이 그룹에 대한 액세스를 제한하도록 구성되어 있는지 확인하십시오
if grep -q "^auth\s*required\s*pam_wheel.so\s*group=$group" /etc/pam.d/su; then
  OK "su 명령은 $group 그룹으로 제한됩니다."
else
  WARN "su 명령은 $group 그룹으로 제한되지 않습니다."
fi

 

cat $result

echo ; echo
