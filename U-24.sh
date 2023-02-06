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

result=$(ps -ef | egrep "nfs|statd|lockd")
if [ "$result" != "" ]; then
    WARN "NFS 관련 프로세스 발견: $result"
else
    OK "NFS 관련 프로세스를 찾을 수 없습니다."
fi

 
cat $result

echo ; echo