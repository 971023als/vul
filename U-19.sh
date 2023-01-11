#!/bin/bash

 

. function.sh

 

BAR

CODE [U-19] finger 서비스 비활성화

cat << EOF >> $U19

[양호]: Finger 서비스가 비활성화 되어 있는 경우

[취약]: Finger 서비스가 활성화 되어 있는 경우

EOF

BAR

 

SERVICENAME='finger.socket'

systemctl list-unit-files | grep -q $SERVICENAME | grep -v UNIT | \

#grep -v 'unit-files' \

#grep $SERVICENAME >/dev/null 2>&1

 

if [ $? -eq 0 ] ; then

INFO 'Finger 서비스가 설치되어 있습니다.'

STATUS=$(systemctl is-active $SERVICENAME)

if [ $STATUS = 'active' ] ; then

WARN 'Finger 서비스가 활성화 되어 있습니다.'

else 

OK '서비스가 비활성화 되어 있습니다.'

fi

else

OK 'Finger 서비스가 설치 되어 있지 않습니다.'

fi

 

cat $U19

echo ; echo
