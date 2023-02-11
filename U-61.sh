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

# FTP 서비스의 상태를 확인합니다
ftp_status=$(service ftp status 2>&1)

# FTP 서비스가 실행 중인지 확인합니다
if ps -ef | grep -q 'ftp'; then
  WARN "FTP 서비스가 실행 중입니다."
else
  OK "FTP 서비스가 실행되고 있지 않습니다."
  INFO "서비스 상태: $ftp_status"
fi


cat $result

echo ; echo 
