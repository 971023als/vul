#!/bin/bash

 

. function.sh

 

TMP1=`SCRIPTNAME`.log

> $TMP1

TMP2=/tmp/tmp2

> $TMP2

 

BAR

CODE [U-21] r 계열 서비스 비활성화

cat << EOF >> $TMP1

[양호]: r 계열 서비스가 비활성화 되어 있는 경우

[취약]: r 계열 서비스가 활성화 되어 있는 경우

EOF

BAR

 

 

 

SERVICE_LIST='rlogin.socket rexec.socket rsh.socket'

for SERVICE in $SERVICE_LIST

do

#echo $SERVICE

STATUS=$(systemctl is-active $SERVICE)

if [ $STATUS = 'active' ] ; then

echo "[ WARN ] $SERVICE is Active". >> $TMP1

else

echo "[ OK ] $SERVICE not configured">> $TMP1

fi

done

 

if grep -q WARN $TMP1 ; then

WARN 'r 계열 서비스가 활성화 되어 있습니다.'

INFO "$TMP1 파일의 내용을 참고 하세요."

else

OK 'r 계열 서비스가 비활성회 되어 있습니다.'

fi

 

cat $TMP1

echo ; echo