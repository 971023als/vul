#!/bin/bash

 

. function.sh

TMP1=`SCRIPTNAME`.log

>$TMP1  

 

 

BAR

CODE [U-20] Anonymous FTP 비활성화

cat << EOF >> $result

[양호]: Anonymous FTP (익명 ftp) 접속을 차단한 경우

[취약]: Anonymous FTP (익명 ftp) 접속을 차단하지 않은 경우

EOF

BAR

TMP1=`SCRIPTNAME`.log

>$TMP1  

# "ftp" 사용자가 "/etc/passwd" 파일에 있는지 확인하십시오
if grep -q "ftp" /etc/passwd; then
    WARN "'ftp' 사용자가 '/etc/passwd' 파일에 있습니다."
else
    OK "'ftp' 사용자가 '/etc/passwd' 파일에 없습니다."
fi
 

cat $result

echo ; echo
