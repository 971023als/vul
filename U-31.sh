#!/bin/bash

 

. function.sh

 

 

BAR

CODE [U-31] 스팸 메일 릴레이 제한

cat << EOF >> $RESULT

[양호]: SMTP 서비스를 사용하지 않거나 릴레이 제한이 설정되어 있는 경우

[취약]: SMTP 서비스를 사용하며 릴레이 제한이 설정되어 있지 않은 경우

EOF

BAR

 

TMP1=$(mktemp)

TMP2=$(mktemp)

FILE=/etc/mail/sendmail.cf

 

ps -ef | grep sendmail | grep -v grep > $TMP1

 

if [ -z $TMP1 ] ; then

OK SMTP서비스를 사용하지 않습니다.

else

cat $FILE | grep "R$\*" | grep "Relaying denied">$TMP2

CHECK=`cut -c 1 $TMP2`

if [ $CHECK == "#" ] ; then

WARN SMTP 릴레이 제한이 설정되어 있지 않습니다. 

INFO $FILE 의 Relaying denied 주석을 제거 하고 /etc/mail/access에 지정하십시오.

else

OK SMTP 릴레이 제한이 설정되어 있습니다.

fi

fi

 

echo >>$RESULT

echo >>$RESULT