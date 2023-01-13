#!/bin/bash

 

. function.sh

 
TMP1=`SCRIPTNAME`.log

> $TMP1 
 

BAR

CODE [U-63] ftpusers 파일 소유자 및 권한 설정

cat << EOF >> $result

[양호]: ftpusers 파일의 소유자가 root이고, 권한이 640 이하인 경우

[취약]: ftpusers 파일의 소유자가 root아니거나, 권한이 640 이하가 아닌 경우

EOF

BAR

ftp=$(stat -c %U /etc/vsftpd/ftpusers)
dec_perms=$(printf "%d" $ftp)
if [ $ftp -ne "root" ]; then

    WARN "ftpusers file 소유자는 루트가 아닙니다."
fi

# Check permissions of ftpusers file
dec_perms=$(printf "%d" $ftp)
if [ $dec_perms -lt 640 ]; then
    OK " ftpusers file의 권한이 640 미만입니다."

fi    

OK "ftpusers 파일의 소유자가 root이고, 권한이 640 이하입니다"

 




cat $result

echo ; echo 

 
