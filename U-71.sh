#!/bin/bash

 

. function.sh

 

 

BAR

CODE [U-71] Apache 웹서비스 정보 숨김

cat << EOF >> $RESULT

[양호]: ServerTokens 지시자에 Prod 옵션이 설정되어 있는 경우

[취약]: ServerTokens 지시자에 Prod 옵션이 설정되어 있지 않는 경우

EOF

BAR

 

FILE=/etc/httpd/conf/httpd.conf

 

ps -ef | grep httpd | grep -v grep >/dev/null 2>&1

 

if [ $? -eq 0 ] ; then

CHECK=`cat $FILE | grep -i servertokens | awk '{print $2}'`

if [ $CHECK = 'Prod' ] ; then

OK Apache 웹 서비스 정보가 숨겨져 있습니다.

else

WARN Apache 웹 서비스 정보가 노출되고 있습니다. 

fi

else

OK Apache 웹 서비스를 사용하지 않습니다. 

fi

 

echo >>$RESULT

echo >>$RESULT
