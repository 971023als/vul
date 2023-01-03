#!/bin/bash

 

. function.sh

 

 

BAR

CODE [U-35] Apache 디렉터리 리스팅 제거

cat << EOF >> $RESULT

[양호]: 디렉터리 검색 기능을 사용하지 않는 경우

[취약]: 디렉터리 검색 기능을 사용하는 경우

EOF

BAR

 

TMP1=$(mktemp)

FILE=/etc/httpd/conf/httpd.conf

 

ps -ef | grep apache | grep -v grep >/dev/null 2>&1

 

if [ $? -eq 0 ] ; then

cat $FILE | grep -w Options | grep -v '^#' | grep Indexes > $TMP1

if [ -z $TMP1 ] ; then

OK 디렉터리 검색 기능을 사용하지 않습니다.

else

WARN 디렉터리 검색 기능을 사용하고 있습니다. $FILE의 Indexes 옵션을 제거 하십시오.

fi

else

OK Apache서버를 사용하지 않습니다. 

fi

 

echo >>$RESULT

echo >>$RESULT
