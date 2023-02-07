#!/bin/bash

 

. function.sh

TMP1=`SCRIPTNAME`.log

> $TMP1 


BAR

CODE [U-24] NFS 서비스 비활성화 

cat << EOF >> $result

[양호]: 불필요한 NFS 서비스가 비활성화 되어있는 경우

[취약]: 불필요한 NFS 서비스가 활성화 되어있는 경우

EOF

BAR

NFS_DAEMON="nfsd"

result=$(ps -ef | egrep "nfs|statd|lockd")
if [ -z "$result" ]; then
    INFO "NFS 서비스 데몬을 찾을 수 없습니다."
else
    if echo "$result" | grep -q "$NFS_DAEMON"; then
        WARN "NFS 서비스 데몬이 실행 중입니다."
    else
        OK "NFS 서비스 데몬이 실행되고 있지 않습니다."
    fi
fi


 
cat $result

echo ; echo