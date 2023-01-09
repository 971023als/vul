#!/bin/bash

 

. function.sh

 

 

BAR

CODE [U-30] Sendmail 버전 점검

cat << EOF >> $RESULT

[양호]: Sendmail 버전이 8.13.8 이상인 경우

[취약]: Sendmail 버전이 8.13.8 이상이 아닌 경우

EOF

BAR

 

TMP1=$(mktemp)

TMP2=$(mktemp)

 

QUIT () { sleep 1 ; echo "quit"; }

 

ps -ef | grep sendmail | grep -v grep > $TMP1

 

if [ -z $TMP1 ] ; then

OK sendmail을 사용하지 않습니다.

else

QUIT | telnet localhost 25 > $TMP2 2>&1

VERSION=`cat $TMP2 | grep Sendmail | awk '{print $5}' | awk -F/ '{print $1}'`

if [ $VERSION -ge 8 ] ; then

OK Sendmail $VERSION 사용중입니다.

else

WARN Sendmail $VERSION 사용중입니다. 8.13.8 버전으로 업데이트 하십시오.

fi

fi

 

echo >>$RESULT

echo >>$RESULT

 
