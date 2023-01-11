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


# Use the umask command to check the current umask value
current_umask=$(umask)

# Compare the current umask value to 022 or higher
if [[ "$current_umask" -ge 22 ]]; then
    OK "UMASK 값이 022 이상으로 설정됨"
else
    WARN "UMASK 값이 022 이상으로 설정되지 않음"
fi


cat $TMP1

echo ; echo 

 
