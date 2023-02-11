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

# FTP 서비스 조회
hidden_files=$(ps -ef | grep vsftpd | grep -v grep)

# /etc/passwd 파일에서 FTP 계정의 항목을 가져옵니다
ftp_entry=$(grep "^ftp:" /etc/passwd)

# FTP 계정의 셸을 확인하여 변경 사항 확인
ftp_shell=$(grep "^ftp:" /etc/passwd | awk -F: '{print $7}')


if [ ! -f $hidden_files ]; then
  WARN FTP 서비스를 사용하고 있습니다.
else
  if [ "$ftp_shell" == "/bin/false" ]; then
    OK "FTP 계정의 셸이 /bin/false로 설정되었습니다."
  else
    INFO "FTP 계정의 셸을 /bin/false로 설정할 수 없습니다."
  fi
fi

cat $result

echo ; echo 

 
