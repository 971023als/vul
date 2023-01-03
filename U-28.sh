#!/bin/bash

 

. function.sh

 

 

BAR

CODE [U-28] NIS, NIS+ 점검 

cat << EOF >> $RESULT

[양호]: NIS 서비스가 비활성화 되어 있거나. 필요 시 NIS+를 사용하는 경우

[취약]: NIS 서비스가 활성화 되어 있는 경우

EOF

BAR

 

TMP=$(mktemp)

 

ps -ef | egrep "ypserv|ypbind|ypxfrd|rpc.yppasswdd|rpc.ypupdated" | grep -v grep | awk '{print $2,$6}'> $TMP

 

if [ -n $TMP ] ; then

OK NIS 서비스가 비활성화 되어있습니다.

else

cat $TMP | while read PID PROCESS

do

WARN $PID / $PROCESS 가 구동중 입니다. 

done

fi

 

echo >>$RESULT

echo >>$RESULT

 
