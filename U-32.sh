#!/bin/bash

 

. function.sh

 

 

BAR

CODE [U-32] 일반사용자의 Sendmail 실행 방지

cat << EOF >> $RESULT

[양호]: SMTP 서비스 미사용 또는, 일반 사용자의 Sendmail 실행 방지가 설정된 경우

[취약]: SMTP 서비스 사용 및 일반 사용자의 Sendmail 실행 방지가 설정되어 있지 않은 경우

EOF

BAR

 

TMP1=$(mktemp)

FILE=/etc/mail/sendmail.cf

 

ps -ef | grep sendmail | grep -v grep > $TMP1

 

if [ -z $TMP1 ] ; then

OK SMTP서비스를 사용하지 않습니다.

 

else

grep -v '^ *#' /etc/mail/sendmail.cf | grep -i privacyoptions \ | grep restrictqrun >/dev/null 2>&1

 

if [ $? -eq 0 ] ; then

OK 일반 사용자의 Sendmail 실행 방지가 설정 되어 있습니다.

else

WARN 일반 사용자의 Sendmail 실행 방지가 설정 되어 있지 않습니다.

INFO $FILE1 의 PrivacyOtions에 restrictqrun 옵션을 추가하십시오.

fi

fi

 

echo >>$RESULT

echo >>$RESULT

 
