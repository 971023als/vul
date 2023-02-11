#!/bin/bash

 

. function.sh

TMP1=`SCRIPTNAME`.log

> $TMP1   

 

BAR

CODE [U-61] ftp 서비스 확인

cat << EOF >> $result

[양호]: FTP 서비스가 비활성화 되어 있는 경우

[취약]: FTP 서비스가 활성화 되어 있는 경우

EOF

BAR

# FTP 서비스 조회
hidden_files=$(ps -ef | grep vsftpd | grep -v grep)

if [ $hidden_files -eq 0 ] ; then

    WARN FTP 서비스를 사용하고 있습니다.

else

    OK FTP 서비스를 사용하고 있지 않습니다. 

fi

cat $result

echo ; echo 
