#!/bin/bash

. function.sh

TMP1=`SCRIPTNAME`.log

>$TMP1

BAR

CODE [U-07] /etc/passwd 파일 소유자 및 권한 설정

cat << EOF >> $result

[ 양호 ] : /etc/passwd 파일의 소유자가 root이고, 권한이 644 이하인 경우

[ 취약 ] : /etc/passwd 파일의 소유자가 root가 아니거나, 권한이 644 이하가 아닌 경우

EOF

BAR



# 파일이 루트에 의해 소유되는지 확인합니다
if [ $(stat -c "%U" /etc/passwd) != "root" ]; then
    WARN "/etc/passwd 파일이 루트에 의해 소유되지 않습니다."
fi

# 파일 사용 권한이 644보다 작은지 확인합니다
if [ $(stat -c "%a" /etc/passwd) -lt 644 ]; then
    WARN "/etc/passwd 파일의 권한이 644보다 작습니다."
fi

OK "/etc/passwd 파일은 루트에 의해 소유되며 644 이상의 권한을 가집니다."


cat $result

echo ; echo
