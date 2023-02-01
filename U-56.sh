#!/bin/bash

 

. function.sh


TMP1=`SCRIPTNAME`.log

> $TMP1 

 

BAR

CODE [U-56] UMASK 설정 관리 

cat << EOF >> $result

[양호]: UMASK 값이 022 이하로 설정된 경우

[취약]: UMASK 값이 022 이하로 설정되지 않은 경우 

EOF

BAR


# umask 명령을 사용하여 현재 umask 값을 확인합니다
current_umask=$(umask)

# 현재 umask 값을 022 이상과 비교합니다
if [[ "$current_umask" -ge 22 ]]; then
    OK "UMASK 값이 022 이상으로 설정됨"
else
    WARN "UMASK 값이 022 이상으로 설정되지 않음"
fi


cat $result

echo ; echo 

 
