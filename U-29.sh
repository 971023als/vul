#!/bin/bash

 

. function.sh

 

 

BAR

CODE [U-29] tftp, talk 서비스 비활성화

cat << EOF >> $RESULT

[양호]: tftp, talk, ntalk 서비스가 비활성화 되어 있는 경우

[취약]: tftp, talk, ntalk 서비스가 활성화 되어 있는 경우

EOF

BAR

 

TMP=$(mktemp)

cat << EOF >> $TMP

tftp

talk

ntalk

EOF

 

cat $TMP | while read DAEMON

do

ls -l /etc/xinetd.d/$DAEMON >/dev/null 2>&1

if [ $? -ne 0 ] ; then

OK $DAEMON 이 비활성화 되어 있습니다.

else

CHECK=`cat /etc/xinet.d/$DAEMON | grep disable | awk -F= '{print $2}'`

if [ $CHECK == 'yes' ] ; then

OK $DAEMON이 비활성화 되어 있습니다.

else

WARN $DAEMON이 활성화 되어 있습니다.

fi

fi

done

 

echo >>$RESULT

echo >>$RESULT
