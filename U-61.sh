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
fi

# FTP 포트가 수신 중인지 확인합니다
if netstat -tnlp | grep -q ':21'; then
  WARN "FTP 포트(21)가 열려 있습니다."
else
  OK "FTP 포트(21)가 열려 있지 않습니다."
fi

# /etc/passwd에서 FTP 계정을 확인합니다
ftp_entry=$(grep "^ftp:" /etc/passwd)

# FTP 계정의 셸을 확인합니다
ftp_shell=$(grep "^ftp:" /etc/passwd | awk -F: '{print $7}')

if [ "$ftp_shell" == "/bin/false" ]; then
  WARN "FTP 계정(ftp)이 로그인할 수 없습니다."
else
  OK "FTP 계정(ftp)이 로그인할 수 있습니다."
fi

cat $result

echo ; echo 
