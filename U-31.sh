#!/bin/bash

 

. function.sh

 

 

BAR

CODE [U-31] 스팸 메일 릴레이 제한

cat << EOF >> $RESULT

[양호]: SMTP 서비스를 사용하지 않거나 릴레이 제한이 설정되어 있는 경우

[취약]: SMTP 서비스를 사용하며 릴레이 제한이 설정되어 있지 않은 경우

EOF

BAR


if grep -q "^relay_domains =" /etc/postfix/main.cf; then
    WARN "SMTP 서비스를 사용하며 릴레이하도록 구성되었습니다"
else
    OK "SMTP 서비스를 사용하며 릴레이하도록 구성되지 않았습니다."
fi

cat $RESULT

echo ; echo
 
