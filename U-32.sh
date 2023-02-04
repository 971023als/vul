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


# SMTP 서비스가 실행 중인지 확인합니다
if ps aux | grep -q "smtp"; then
  WARN "SMTP 서비스가 실행 중입니다"
else
  OK "SMTP 서비스가 실행되고 있지 않습니다"
fi

# /etc/mail/submit.cf에서 sendmail_enable 변수가 NO로 설정되어 있는지 확인합니다
if grep -q "^O sendmail_enable=NO" /etc/mail/submit.cf; then
  OK "Sendmail 실행에 대한 최종 사용자 보호가 활성화되었습니다"
else
  WARN "Sendmail 실행에 대한 최종 사용자 보호가 활성화되지 않았습니다"
fi


cat $result

echo ; echo
 
