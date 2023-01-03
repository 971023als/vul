#!/bin/bash

 

. function.sh

 

 

BAR

CODE [U-64] ftpusers 파일 설정

cat << EOF >> $RESULT

[양호]: FTP 서비스가 비활성화 되어 있거나, 활성 시 root 계정 접속을 차단한 경우

[취약]: FTP 서비스가 활성화 되어 있고, root 계정 접속을 허용한 경우

EOF

BAR

 

FILE=/etc/vsftpd/ftpusers

 

ps -ef | grep vsftpd | grep -v grep >/dev/null 2>&1

 

if [ $? -ne 0 ] ; then

OK FTP 서비스가 비활성화 되어 있습니다. 

exit 1

else

cat $FILE | grep ^root >/dev/null 2>&1

 

if [ $? -eq 0 ] ; then

OK root 계정 접속이 차단되어 있습니다.

else

WARN root 계정 접속이 차단되지 않았습니다. 

INFO $FILE에 root 계정을 추가 하십시오, 

fi

fi

 

echo >>$RESULT

echo >>$RESULT

 
