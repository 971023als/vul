#!/bin/bash

 

. function.sh

 
TMP1=`SCRIPTNAME`.log

> $TMP1  
 

BAR

CODE [U-26] automountd 제거 '확인 필요'

cat << EOF >> $result

[양호]: automountd 서비스가 비활성화 되어있는 경우

[취약]: automountd 서비스가 활성화 되어있는 경우

EOF

BAR

 

if systemctl is-active --quiet automount; then
    WARN "automountd 실행 중입니다"
else
    OK "automountd 실행되고 있지 않습니다"
fi


 

cat $TMP1

echo ; echo