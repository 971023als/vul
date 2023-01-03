#!/bin/bash

 

. function.sh

 

BAR

CODE [U-68] 로그온 시 경고 메시지 제공

cat << EOF >> $RESULT

[양호]: 서버 및 Telnet 서비스에 로그온 메시지가 설정되어 있는 경우

[취약]: 서버 및 Telnet 서비스에 로그온 메시지가 설정되어 있지 않은 경우

EOF

BAR

 

FILE1=/etc/motd

FILE2=/etc/issue.net

 

FILESIZE=`ls -l $FILE1 | awk '{print $5}'`

 

if [ -n $FILESIZE ] ; then

WARN 서버 로그온 메시지가 없습니다. 

INFO $FILE1에 메시지를 추가하십시오.

else

OK 서버 로으노 메시지가 있습니다.

fi

 

cat $FILE2 | egrep 'CentOS release|Kernel' >/dev/null 2>&1

 

if [ $? -eq 0 ] ; then

WARN Telnet 로그온 메시지를 변경하십시오.

INFO $FILE2에 메시지를 변경하십시오.

else

OK Telnet 로그온 메시지가 있습니다.

fi

 

echo >>$RESULT

echo >>$RESULT

 
