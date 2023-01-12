#!/bin/bash

 

. function.sh

 

TMP1=`SCRIPTNAME`.log

>$TMP1

 

 

BAR 

CODE [U-08] /etc/shadow 파일 소유자 및 권한 설정

cat << EOF >> $result

[양호]: /etc/shadow 파일의 소유자가 root이고, 권한이 400인 경우

[취약]: /etc/shadow 파일의 소유자가 root가 아니거나, 권한이 400이 아닌 경우

EOF

BAR



# check if the file is owned by root
if [ $(stat -c "%U" /etc/shadow) != "root" ]; then
    WARN "/etc/shadow 파일이 루트에 의해 소유되지 않습니다."
fi

# check if the file permissions are less than 400
if [ $(stat -c "%a" /etc/shadow) -lt 400 ]; then
    WARN "/etc/shadow 파일에 400 미만의 권한이 있습니다."
fi

OK "/etc/messages 파일은 루트에 의해 소유되며 400 이상의 권한을 가집니다."


cat $result

echo ; echo
