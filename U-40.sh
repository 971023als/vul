#!/bin/bash

 

. function.sh

 

 

BAR

CODE [U-40] Apache 파일 업로드 및 다운로드 제한 

cat << EOF >> $RESULT

[양호]: 파일 업로드 및 다운로드를 제한한 경우

[취약]: 파일 업로드 및 다운로드를 제한하지 않은 경우

EOF

BAR

 

FILE=/etc/httpd/conf/httpd.conf

TMP=$(mktemp)

TMP2=$(mktemp)

ps -ef | grep httpd | grep -v grep >/dev/null 2>&1

 

if [ $? -eq 0 ] ; then

cat $FILE | sed -n '/\<Directory \/>/,/Directory>/p' | grep LimitRequestBody > $TMP

 

if [ -s /tmp/tmp1 ] ; then

# SIZE=`cat /tmp/tmp1 | awk '{print $2}'`

cat $FILE | grep LimitRequestBody >$TMP2

cat $TMP2 | while read OPTION SIZE

do

if [ $SIZE -gt 5000000 ] ; then

WARN 너무 큰 용량으로 설정되어 있습니다.

else

OK 파일 업로드 및 다운로드를 제한하고 있습니다.

fi

done

else

WARN 파일 업로드 및 다운로드 제한이 필요합니다. 

INFO $FILE의 LimitRequestBody 설정을 하십시오. 

fi

else

OK Apache 서버를 사용하지 않습니다. 

fi

 

echo >>$RESULT

echo >>$RESULT
