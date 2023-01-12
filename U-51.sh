#!/bin/bash

 

. function.sh

 

TMP1=`SCRIPTNAME`.log

TMP2=/tmp/tmp1

TMP3=/tmp/tmp2

TMP4=/tmp/tmp3

 

BAR

CODE [U-51] 계정이 존재하지 않는 GID 금지

cat << EOF >> $result

양호: 존재하지 않는 계정에 GID 설정을 금지한 경우

취약: 존재하지 않은 계정에 GID 설정이 되어있는 경우

EOF

BAR


# Define a list of necessary groups
necessary_groups=("root" "sudo" "sys" "adm" "wheel" "daemon")

# Search for groups that are not in the list of necessary groups
unnecessary_groups=$(getent group | awk -F: '{if (!($1 in necessary_groups)) { print $1 } }')

# Check if any unnecessary groups were found
if [ -n "$unnecessary_groups" ]; then
  WARN "Error: 불필요한 그룹이 발견되었습니다. $unequired_groups"
fi

# If the script reaches this point, no unnecessary groups were found
OK "불필요한 그룹을 찾을 수 없습니다."



 

cat $result

echo ; echo
