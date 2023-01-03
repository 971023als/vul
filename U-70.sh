#!/bin/bash

 

. function.sh

 

 

BAR

CODE [U-70] expn, vrfy 명령어 제한

cat << EOF >> $RESULT

[양호]: SMTP 서비스 미사용 또는, noexpn, novrfy 옵션이 설정되어 있는 경우

[취약]: SMTP 서비스 사용하고, noexpn, novrfy 옵션이 설정되어 있지 않는 경우

EOF

BAR

 

FILE=/etc/mail/sendmail.cf

TMP=$(mktemp)

 

ps -ef | grep sendmail | grep -v grep >/dev/null 2>&1

 

if [ $? -eq 0 ] ; then

cat $FILE | grep PrivacyOptions | grep -v '^#' \

| grep noexpn | grep novrfy >/dev/null 2>&1

if [ $? -eq 0 ] ; then

OK SMTP 옵션 설정이 양호합니다.

else

WARN STMP 옵션이 취약합니다.

INFO $FILE에 PrivacyOptions의 noexpn,novrfy 옵션을 추가하십시오.

fi

else

OK SMTP 서비스를 사용하지 않습니다. 

ls -al /etc/rc*.d/* | grep sendmail | \grep S >$TMP

if [ $? -eq 0 ] ; then

INFO "$TMP 파일을 확인하고 이름을 변경하십시오. (S -> _S or K)"

fi

fi

 

echo >>$RESULT

echo >>$RESULT
