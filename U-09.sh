#!/bin/bash

 

. function.sh

 

TMP1=`SCRIPTNAME`.log

>$TMP1

 

 

BAR

CODE [U-09] /etc/hosts 파일 소유자 및 권한 설정.

cat << EOF >> $result

[양호]: /etc/hosts 파일의 소유자가 root이고, 권한이 600인 경우

[취약]: /etc/hosts 파일의 소유자가 root가 아니거나, 권한이 600이 아닌 경우

EOF

BAR

 

 


# check if the file is not owned by root
if [ $(stat -c "%U" /etc/hosts) == "root" ]; then
    WARN "/etc/hosts 파일이 루트에 의해 소유됩니다."
fi

# check if the file permissions are 600 or higher
if [ $(stat -c "%a" /etc/hosts) -lt 600 ]; then
    WARN "/etc/hosts 파일에 600 이외의 권한이 있습니다"
fi

OK "/etc/hosts 파일이 루트에 의해 소유되지 않으며 600 이상의 권한이 있습니다."


cat $result

echo ; echo
