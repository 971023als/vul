#!/bin/bash

 

. function.sh

 

 

BAR

CODE [U-61] ftp 서비스 확인

cat << EOF >> $RESULT

[양호]: FTP 서비스가 비활성화 되어 있는 경우

[취약]: FTP 서비스가 활성화 되어 있는 경우

EOF

BAR

 

ps -ef | grep vsftpd | grep -v grep >/dev/null 2>&1

 

if [ $? -eq 0 ] ; then

WARN FTP 서비스를 사용하고 있습니다.

else

OK FTP 서비스를 사용하고 있지 않습니다. 

fi

 

echo >>$RESULT

echo >>$RESULT
