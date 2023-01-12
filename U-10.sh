#!/bin/bash

 

. function.sh

 
TMP1=`SCRIPTNAME`.log

>$TMP1

BAR

CODE [U-10] /etc/xinetd.conf 파일 소유자 및 권한 설정 

cat << EOF >> $result

[양호]: /etc/xinetd.conf 파일의 소유자가 root이고, 권한이 600인 경우

[취약]: /etc/xinetd.conf 파일의 소유자가 root가 아니거나, 권한이 600이 아닌경우

EOF

BAR



# check if the file is not owned by root
if [ $(stat -c "%U" /etc/inetd.conf) == "root" ]; then
    WARN "/etc/inetd.conf 파일이 루트에 의해 소유됩니다."
fi

# check if the file permissions are not 600
if [ $(stat -c "%a" /etc/inetd.conf) -ne 600 ]; then
    WARN "/etc/inetd.conf 파일에 600 이외의 권한이 있습니다."
fi

OK "/etc/inetd.conf 파일이 루트에 의해 소유되지 않으며 권한이 600입니다."


cat $result

echo ; echo
 
