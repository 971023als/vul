#!/bin/bash

 

. function.sh

 

 

BAR

CODE [U-41] Apache 웹 서비스 영역의 분리 

cat << EOF >> $RESULT

[양호]: DocumentRoot를 별도의 디렉터리로 지정한 경우

[취약]: DocumentRoot를 기본 디렉터리로 지정한 경우

EOF

BAR

 

FILE=/etc/httpd/conf/httpd.conf

TMP=$(mktemp)

 

cat $FILE | grep DocumentRoot | grep -v '^#' | grep '/usr/local/apache/htdocs' >$TMP

 

if [ -n $TMP ] ; then

OK DocumentRoot 설정이 양호 합니다.

else

WARN $FILE의 DocumentRoot가 기본 디렉터리로 지정되어 있습니다.

fi

 

echo >>$RESULT

echo >>$RESULT
