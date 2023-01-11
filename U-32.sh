#!/bin/bash

 

. function.sh

TMP1=`SCRIPTNAME`.log

> $TMP1 

 

BAR

CODE [U-32] 일반사용자의 Sendmail 실행 방지

cat << EOF >> $result 

[양호]: SMTP 서비스 미사용 또는, 일반 사용자의 Sendmail 실행 방지가 설정된 경우

[취약]: SMTP 서비스 사용 및 일반 사용자의 Sendmail 실행 방지가 설정되어 있지 않은 경우

EOF

BAR


if systemctl is-active --quiet postfix; then
    OK "SMTP 서비스를 사용 중입니다"
else
    WARN "SMTP 서비스를 사용 중 아닙니다"
fi

if [ -x /usr/sbin/sendmail ]; then
    OK "일반 사용자의 sendmail 실행 방지가 설정되어 있습니다"
else
    WARN "일반 사용자의 sendmail 실행 방지가 설정되어 있습니다"
fi

cat $TMP1 

echo ; echo
 
