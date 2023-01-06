#!/bin/bash

 

. function.sh

 

 

BAR

CODE [U-37] Apache 상위 디렉터리 접근 금지 

cat << EOF >> $RESULT

[양호]: 상위 디렉터리에 이동제한을 설정한 경우

[취약]: 상위 디렉터리에 이동제한을 설정하지 않은 경우

EOF

BAR

 

FILE=/etc/apache2/apache2.conf

TMP=/tmp/tmp1

 

TRUEFLASE=1

 

cat $FILE | grep AllowOverride | grep -v '^#' | awk '{print $2}' >$TMP

 

for CHECK in `cat $TMP`

do

if [ $CHECK != 'AuthConfig' -o $CHECK != 'All' ] ; then

TRUEFLASE=0

fi

done

 

if [ $TRUEFLASE -eq 0 ] ; then

WARN 상위 디렉터리에 이동제한이 설정되어 있지 않습니다.

INFO $FILE 의 디렉터리의 AllowOverride 지시자의 옵션을 AuthConfig 또는 All 로 변경하십시오.

else

OK 상위 디렉터리에 이동제한이 설정되어 있습니다.

fi

 

echo >>$RESULT

echo >>$RESULT

 

 

