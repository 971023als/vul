#!/bin/bash

 

. function.sh

TMP1=`SCRIPTNAME`.log

> $TMP1 

 

BAR

CODE [U-24] NFS 서비스 비활성화 '확인 필요'

cat << EOF >> $result

[양호]: 불필요한 NFS 서비스가 비활성화 되어있는 경우

[취약]: 불필요한 NFS 서비스가 활성화 되어있는 경우

EOF

BAR


if systemctl is-active --quiet nfs; then
    WARN "불필요한 NFS 서비스가 실행 중입니다"
else
    OK "불필요한 NFS 서비스가 실행되고 있지 않습니다"
fi


 
cat $TMP1

echo ; echo