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


NC='ps -ef | egrep "nfs|statd|lockd" | grep -v kblock'

if [ -n "$NC" ]; then
WARN " ==> [취약] NFS 서비스가 동작 중입니다."
else
OK " ==> [안전] NFS 서비스가 동작 중이지 않습니다."
fi


 
cat $result

echo ; echo