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

ftp_users=$(grep "^ftp" /etc/passwd | cut -d: -f1)
for user in $ftp_users; do
  if [ "$user" == "root" ]; then
    OK "FTP 연결은 루트 계정에 직접 액세스할 수 있습니다."
  else
    WARN "FTP 연결은 루트 계정에 직접 액세스할 수 없습니다."
  fi
done

cat $result

echo ; echo 


 
