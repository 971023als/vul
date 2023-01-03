#!/bin/bash

 

. function.sh

TMP1=`SCRIPTNAME`.log

> $TMP1

 

 

BAR

CODE [U-20] Anonymous FTP 비활성화

cat << EOF >> $RESULT

[양호]: Anonymous FTP (익명 ftp) 접속을 차단한 경우

[취약]: Anonymous FTP (익명 ftp) 접속을 차단하지 않은 경우

EOF

BAR

 

INFO $TMP1 파일을 점검한다.

 

netstat -antp | grep ftp | awk '{print $7}' | awk -F: '{print $1}' | awk -F/ '{print $2}' >/dev/null 2>&1

 

if [ $? -eq 0 ] ; then 

WARN 'FTP 서비스가 존재합니다'

pgrep -lf vsftpd > vsftpd.pid

if [ -s vsftpd.pid ] ; then 

cat vsftpd.pid > $TMP1

WARN vsftpd 서비스가 동작 중 입니다.

RES=$(cat /etc/vsftpd/vsftpd.conf | egrep -v '^#' \

| egrep anonymous_enable \

| awk -F= '{print $2}')

if [ $RES = 'YES' ] ; then

WARN Anonymous FTP 서비스가 활성화 되어 있습니다.

echo "/etc/vsftpd/vsftpd.conf(anonymous_enable=YES)" >> $TMP1

else

OK Anonymous FTP 서비스가 비활성화 되어 있습니다.

fi

else

OK vsftpd 서비스가 동작 중이 아닙니다.

fi

else

INFO 'FTP 서비스가 존재하지 않습니다'

fi

cat $RESULT

echo ; echo
