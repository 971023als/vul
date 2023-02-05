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

# check if root has a valid shell
if [ $(grep "^root" /etc/passwd | awk -F: '{print $7}') != "/bin/false" ]; then
  echo "Root account has a valid shell. Please set it to /bin/false to prevent direct FTP access."
else
  echo "Root account does not have a valid shell for direct FTP access."
fi



cat $result

echo ; echo 


 
