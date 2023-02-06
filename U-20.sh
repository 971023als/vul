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

# FTP 서비스가 실행 중인지 확인합니다
ftp_status=$(service is-active vsftpd)
if [ "$ftp_status" != "active" ]; then
  OK "FTP 서비스가 실행되고 있지 않습니다"
else
  echo "익명 FTP 연결이 활성화되었습니다"
fi

# vsftpd 구성 파일에서 익명 로그인 설정을 확인하십시오
if grep -q "^anonymous_enable=NO" /etc/vsftpd.conf; then
  echo "익명 FTP 연결 사용 안 함"
else
  echo "오류: 익명 FTP 연결이 활성화되었습니다"
fi

 

cat $result

echo ; echo
