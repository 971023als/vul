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

# FTP 서비스의 상태를 확인합니다
ftp_status=$(service ftp status 2>&1)

# /etc/passwd 파일에서 FTP 계정의 항목을 가져옵니다
ftp_entry=$(grep "^ftp:" /etc/passwd)

# FTP 계정의 셸을 확인하여 변경 사항 확인
ftp_shell=$(grep "^ftp:" /etc/passwd | awk -F: '{print $7}')


if ps -ef | grep -q 'ftp'; then
  if [ "$ftp_shell" == "/bin/false" ]; then
    OK "FTP 계정의 셸이 /bin/false로 설정되었습니다."
  else
    INFO "FTP 계정의 셸을 /bin/false로 설정할 수 없습니다."
  fi
else
  OK "FTP 서비스가 실행되고 있지 않습니다."
  INFO "서비스 상태: $ftp_status"
fi


cat $result

echo ; echo 

 
