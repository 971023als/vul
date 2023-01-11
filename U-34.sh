#!/bin/bash

 

. function.sh

 

 

BAR

CODE [U-34] DNS Zone Transfer 설정

cat << EOF >> $RESULT

[양호]: DNS 서비스 미사용 또는, Zone Transfer를 허가된 사용자에게만 허용한 경우

[취약]: DNS 서비스를 사용하여 Zone Transfer를 모든 사용자에게 허용한 경우

EOF

BAR

 

installed_dns=$(ps -ef | grep named | grep -v grep)
FILE1=/etc/named.conf
# FILE2=/etc/named.rfc1912.zones


# 활성화 여부 확인

if  [-s $installed_dns] ; then
    WARN "DNS 서비스를 사용 중입니다."
else
    OK "DNS 서비스를 사용 중입니다."
fi

# 활성화 여부 확인

if  [-f $FILE1] ; then # 파일 유무 확인
    cat $FILE1 | grep 'allow-transfer' >/dev/null # 허용범위 확인
    if [$? == 0 ] ; then
        OK "Zone Transfer를 허가된 사용자에게만 허용하고 있습니다."
    else
        WARN " Zone Transfer를 허가된 사용자에게만 허용하고 있습니다."
    fi
else
    WARN "$FILE1이 존재하지 있습니다."


cat $RESULT

echo ; echo