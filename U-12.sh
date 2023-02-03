#!/bin/bash

 

. function.sh

 
TMP1=`SCRIPTNAME`.log

>$TMP1  

BAR

CODE [U-12] /etc/services 파일 소유자 및 권한 설정 

cat << EOF >> $result  

[양호]: /etc/services 파일의 소유자가 root이고, 권한이 644 이하

[취약]: /etc/services 파일의 소유자가 root가 아니거나, 권한이 644 이상

EOF

BAR

# 파일이 있는지 확인하십시오
if [ -e "/etc/services" ]; then

# 파일 소유권 확인
    if [ $(stat -c "%U" /etc/services) == "root" ] || [ $(stat -c "%U" /etc/services) == "bin" ] || [ $(stat -c "%U" /etc/services) == "sys" ]; then
        OK "/etc/services 파일이 루트(또는 bin, sys)에 의해 소유됩니다."
    fi

# 파일 사용 권한 확인
    if [ $(stat -c "%a" /etc/services) -gt 644 ]; then
        WARN "/etc/services 파일 사용 권한이 644보다 큽니다."
    else
        OK "/etc/services file is owned by root (or bin, sys) and has 644 or less permissions."
    fi
    else
OK "/etc/services file does not exist"
fi



cat $result

echo ; echo
