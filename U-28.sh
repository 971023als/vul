#!/bin/bash

 

. function.sh

 

 

BAR

CODE [U-28] NIS, NIS+ 점검 

cat << EOF >> $RESULT

[양호]: NIS 서비스가 비활성화 되어 있거나. 필요 시 NIS+를 사용하는 경우

[취약]: NIS 서비스가 활성화 되어 있는 경우

EOF

BAR

 

if systemctl is-active --quiet ypbind; then
    WARN "NIS 서비스가 실행 중입니다"
else
    OK "NIS 서비스가 실행되고 있지 않습니다"
fi

cat $RESULT

echo ; echo
 



 
