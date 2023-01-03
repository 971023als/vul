#!/bin/bash

 

. function.sh

 

 

BAR

CODE [U-24] NFS 서비스 비활성화 '확인 필요'

cat << EOF >> $RESULT

[양호]: 불필요한 NFS 서비스가 비활성화 되어있는 경우

[취약]: 불필요한 NFS 서비스가 활성화 되어있는 경우

EOF

BAR

 

ps -ef | grep yp | grep -v grep >/dev/null 2>&1

 

if [ $? -eq 0 ] ; then

WARN NFS 서비스가 활성화 되어 있습니다.

INFO 서비스 정지 /usr/lib/netsvc/yp/ypstop

INFO rm -r /var/yp/blue.org

INFO rm /etc/ethers /etc/netgroup /etc/timezone /etc/bootparams

INFO vi /etc/nsswitch.conf

else

OK NFS 서비스가 비활성화 되어 있습니다. 

fi

 

echo >>$RESULT

echo >>$RESULT