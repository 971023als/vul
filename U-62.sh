#!/bin/bash

 

. function.sh

 
TMP1=`SCRIPTNAME`.log

> $TMP1 
 

BAR

CODE [U-62] ftp 계정 shell 제한

cat << EOF >> $result

[양호]: ftp 계정에 /bin/false 쉘이 부여되어 있는 경우

[취약]: ftp 계정에 /bin/false 쉘이 부여되지 않 경우

EOF

BAR

# /etc/passwd 파일에서 FTP 계정의 항목을 가져옵니다
ftp_entry=$(grep "^ftp:" /etc/passwd)

# /etc/passwd 파일에서 FTP 계정의 항목을 가져옵니다
ftp_shell=$(echo $ftp_entry | awk -F: '{print $7}')

# FTP 계정의 셸을 /bin/false와 비교합니다
if [ "$ftp_shell" == "/bin/false" ]; then
  OK "FTP 계정이 /bin/false 셸이 부여되었습니다."
else
  WARN "FTP 계정이 /bin/false 셸이 부여되지 않았습니다."
fi



cat $result

echo ; echo 

 
