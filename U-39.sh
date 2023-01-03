#!/bin/bash

 

. function.sh


 

BAR

CODE [U-39] Apache 링크 사용 금지 

cat << EOF >> $RESULT

[양호]: 심볼릭 링크, aliases 사용을 제한한 경우

[취약]: 심볼릭 링크, aliases 사용을 제한하지 않은 경우

EOF

BAR

 

FILE=/etc/httpd/conf/httpd.conf

TMP=$(mktemp)

 

TRUEFLASE=0

 

cat $FILE | grep Options | grep -v '^#' | grep FollowSymLinks >$TMP

 

if [ -z $TMP ] ; then

OK 심볼릭 링크를 사용하지 않습니다.

else

WARN 심볼릭 링크를 사용하고 있습니다.

INFO $FILE에 설정된 디렉터리의 Options의 FollowSymLinks를 제거 하십시오.

fi

 

echo >>$RESULT

echo >>$RESULT

 
