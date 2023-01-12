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


# Check if the nfs daemon is enabled
if systemctl is-enabled nfs-server.service; then
    WARN "NFS 서버 데몬 사용"
else
    OK "NFS 서버 데몬 사용되지 않음"
fi

# Check if the nfslock daemon is enabled
if systemctl is-enabled nfs-lock.service; then
    WARN "NFS 잠금 데몬 사용"
else
    OK "NFS 잠금 데몬 사용되지 않음"
fi

# Check if the rpcbind daemon is enabled
if systemctl is-enabled rpcbind.service; then
    WARN "RPC 바인딩 데몬 사용"
else
    OK "RPC 바인딩 데몬 사용되지 않음"
fi


 
cat $result

echo ; echo