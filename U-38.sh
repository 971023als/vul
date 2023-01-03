#!/bin/bash

 

. function.sh

 

 

BAR

CODE [U-38] Apache 불필요한 파일 제거 

cat << EOF >> $RESULT

[양호]: 매뉴얼 파일 및 디렉터리가 제거되어 있는 경우

[취약]: 매뉴얼 파일 및 디렉터리가 제거되지 않은 경우

EOF

BAR

 

FILE=/etc/httpd

TRUEFLASE=0

 

ls -ld $FILE/htdocs/manual >/dev/null 2>&1

 

if [ $? -eq 0 ] ; then

WARN $FILE/htdocs/manual이 존재합니다. 

else

TRUEFLASE=1

fi

 

ls -ld $FILE/manual >/dev/null 2>&1

 

if [ $? -eq 0 ] ; then

WARN $FILE/manual이 존재합니다.

else

TRUEFLASE=1

fi

 

if [ -n $TUREFLASE ] ; then

OK 매뉴얼 파일 및 디렉터리가 존재하지 않습니다.

fi

 

echo >>$RESULT

echo >>$RESULT