#!/bin/bash

 

. function.sh

 

 

BAR

CODE [U-36] Apache 웹 프로세스 권한 제한 

cat << EOF >> $RESULT

[양호]: Apache 데몬이 root 권한으로 구동되지 않는 경우

[취약]: Apache 데몬이 root 권한으로 구동되는 경우

EOF

BAR

 

FILE=/etc/httpd/conf/httpd.conf

 

APACHEUSER=`cat $FILE | grep ^User | awk '{print $2}'`

APACHEGROUP=`cat $FILE | grep ^Group| awk '{print $2}'` 

 

TRUEFLASE=1

 

if [ $APACHEUSER = "root" ] ; then

TRUEFLASE=0

fi

 

if [ $APACHEGROUP = "root" ] ; then

TRUEFLASE=0

fi

 

if [ -z $TRUEFLASE ] ; then

WARN Apache 데몬이 root의 권한으로 구동되고 있습니다.

INFO $FILE의 User와 Group의 계정을 root가 아닌 사용자로 바꾸십시오.

else

OK Apache 데몬이 root의 권한으로 구동되지 않습니다.

fi

 

echo >>$RESULT

echo >>$RESULT

 
