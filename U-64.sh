#!/bin/bash

 

. function.sh

 
TMP1=`SCRIPTNAME`.log

> $TMP1 
 

BAR

CODE [U-64] ftpusers 파일 설정

cat << EOF >> $result

[양호]: FTP 서비스가 비활성화 되어 있거나, 활성 시 root 계정 접속을 차단한 경우

[취약]: FTP 서비스가 활성화 되어 있고, root 계정 접속을 허용한 경우

EOF

BAR

TMP1=`SCRIPTNAME`.log

> $TMP1 

# /etc/ftpusers 파일이 있고 내용이 있는지 확인하십시오
if [ -s /etc/ftpusers ]; then
  OK "일부 사용자에 대해 FTP 서비스가 비활성화되었습니다. 자세한 내용은 /etc/ftpusers를 확인하십시오."
else
  INFO "/etc/ftp 사용자에서 제한을 찾을 수 없습니다. 루트 로그인 제한을 확인합니다."
fi

# /etc/proftpd.conf에서 RootLogin이 off로 설정되어 있는지 확인합니다
root_login=$(grep -i "RootLogin" /etc/proftpd.conf)
if [ -n "$root_login" ]; then
  if [ "$root_login" == "RootLogin off" ]; then
    OK "루트 로그인이 /etc/proftpd.conf에서 비활성화되었습니다."
  else
    WARN "루트 로그인이 /etc/proftpd.conf에서 활성화되었습니다."
  fi
else
  INFO "/etc/proftpd.conf에서 정보를 찾을 수 없습니다. /etc/vsftp/ftp 사용자를 확인합니다."
fi

# Check if /etc/vsftp/ftpusers file exists and has content
if [ -s /etc/vsftp/ftpusers ]; then
  OK "일부 사용자에 대해 FTP 서비스가 비활성화되었습니다. 자세한 내용은 /etc/vsftp/ftpusers를 확인하십시오."
else
  WARN "/etc/vsftp/ftp 사용자에서 제한을 찾을 수 없습니다."
fi
	


cat $result

echo ; echo 


 
