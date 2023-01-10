#!/bin/bash

 

. function.sh

 

 

BAR

CODE [U-34] DNS Zone Transfer 설정

cat << EOF >> $RESULT

[양호]: DNS 서비스 미사용 또는, Zone Transfer를 허가된 사용자에게만 허용한 경우

[취약]: DNS 서비스를 사용하여 Zone Transfer를 모든 사용자에게 허용한 경우

EOF

BAR

 

 

ps -ef | grep named | grep -v grep >/dev/null 2>&1

 

if [ $? -eq 0 ] ; then

cat /etc/named.* | egrep -v '(^#|^$|^//)'| grep allow-transfer > $TMP 2>&1

if [ -s $TMP ] ; then

OK Zone Transfer 설정 되어있습니다. 

INFO $TMP 파일을 확인하십시오.

else

WARN Zone Transfer 설정이 되어 있지 않습니다.

fi

else 

OK DNS 서비스를 사용하고 있지 않습니다.

fi

 

echo >>$RESULT

echo >>$RESULT