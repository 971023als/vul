#!/bin/bash

 

. function.sh

 

 

BAR

CODE [U-72] 정책에 따른 시스템 로깅 설정

cat << EOF >> $RESULT

[양호]: 로그 기록 정책이 정책에 따라 설정되어 수립되어 있는 경우

[취약]: 로그 기록 정책이 정책에 따라 설정되어 수립되어 있지 않은 경우

EOF

BAR

 

FILE=/etc/syslog.conf

FILE1=./log/`SCRIPTNAME`.log

> $FILE1

 

cat << EOF >> $FILE1

*.info;mail.none;authpriv.none;cron.none /var/log/messages

authpriv.* /var/log/secure

mail.* /var/log/maillog

cron.* /var/log/cron

*.alert /dev/console

*.emerg *

EOF

 

FILE2=$(mktemp)

 

cat $FILE | egrep -v '^#|^$' >$FILE2

 

diff -b $FILE1 $FILE2 | grep '<' /dev/null 2>&1

 

if [ $? -eq 0 ] ; then

OK 로그 기록 정책 설정이 양호합니다.

else

WARN 로그 기록 정책 설정이 취약합니다. 

INFO $FILE에 $FILE1 내용을 추가/변경 하십시오.

fi

 

 

echo >>$RESULT

echo >>$RESULT

 
