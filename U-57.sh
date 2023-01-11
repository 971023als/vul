#!/bin/bash

 

. function.sh

 

 

BAR

CODE [U-57] 홈 디렉터리 소유자 및 권한

cat << EOF >> $RESULT

[양호]: 홈 디렉터리 소유자가 해당 계정이고, 일반 사용자 쓰기 권한이 제거된 경우

[취약]: 홈 디렉터리 소유자가 해당 계정이 아니고, 일반 사용자 쓰기 권한이 부여된 경우 

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


cat $RESULT

echo ; echo 


 
