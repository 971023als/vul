#!/bin/bash

 

. function.sh

 

BAR

CODE [U-27]  RPC 서비스 확인 '확인 필요'

cat << EOF >> $U27

[양호]: 불필요한 RPC 서비스가 비활성화 되어 있는 경우

[취약]: 불필요한 RPC 서비스가 활성화 되어 있는 경우


EOF

BAR

 

if systemctl is-active --quiet rpcbind; then
    WARN "불필요한 RPC 서비스가 실행 중입니다"
else
    OK "불필요한 RPC 서비스가 실행되고 있지 않습니다"
fi


 

cat $U27

echo ; echo