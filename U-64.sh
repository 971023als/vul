#!/bin/bash

 

. function.sh

 
TMP1=`SCRIPTNAME`.log

> $TMP1 
 

BAR

CODE [U-64] ftpusers 파일 설정

cat << EOF >> $TMP1

[양호]: FTP 서비스가 비활성화 되어 있거나, 활성 시 root 계정 접속을 차단한 경우

[취약]: FTP 서비스가 활성화 되어 있고, root 계정 접속을 허용한 경우

EOF

BAR



# check if the vsftpd service is active
if ! systemctl is-active --quiet vsftpd; then
    WARN "FTP 서비스가 활성화되지 않았습니다."
else
    OK "FTP 서비스 사용 중 입니다."

    # check if the ftp root login is allowed
    if grep -q "root" /etc/vsftpd/vsftpd.conf; then
        WARN "루트 계정 액세스가 허용됨"
    else
        OK "루트 계정 액세스가 허용되지 않음"
    fi
fi


cat $TMP1

echo ; echo 


 
