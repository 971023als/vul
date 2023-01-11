#!/bin/bash

 

. function.sh

 

 

BAR

CODE [U-61] ftp 서비스 확인

cat << EOF >> $U61

[양호]: FTP 서비스가 비활성화 되어 있는 경우

[취약]: FTP 서비스가 활성화 되어 있는 경우

EOF

BAR


# check if the vsftpd service is active
if systemctl is-active --quiet vsftpd; then
    WARN "FTP 서비스가 활성화되어 있습니다"
else
    OK "FTP 서비스가 활성화되지 않았습니다."
fi



cat $U61

echo ; echo 
