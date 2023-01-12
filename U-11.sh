#!/bin/bash

 

. function.sh

TMP1=`SCRIPTNAME`.log

>$TMP1 


BAR

CODE [U-11] /etc/syslog.conf 파일 소유자 및 권한 설정 

cat << EOF >> $result 

[양호]: /etc/syslog.conf 파일의 소유자가 root이고, 권한이 644인 경우

[취약]: /etc/syslog.conf 파일의 소유자가 root가 아니거나, 권한이 644가 아닌경우

EOF

BAR



# check if the file is not owned by root or bin or sys
if [ $(stat -c "%U" /etc/syslog.conf) == "root" ] || [ $(stat -c "%U" /etc/syslog.conf) == "bin" ] || [ $(stat -c "%U" /etc/syslog.conf) == "sys" ]; then
    WARN "/etc/syslog.conf 파일은 root 또는 bin 또는 sys에 의해 소유됩니다."
fi

# check if the file permissions are less than 640
if [ $(stat -c "%a" /etc/syslog.conf) -lt 640 ]; then
    WARN "/etc/syslog.conf 파일의 권한이 640보다 작습니다."
fi

OK "/etc/syslog.conf 파일은 루트 또는 bin 또는 sys에서 소유하지 않으며 640 이상의 권한을 가집니다."


cat $result

echo ; echo

 



 
