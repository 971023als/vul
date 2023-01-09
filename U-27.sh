#!/bin/bash

 

. function.sh

 

BAR

CODE [U-27]  RPC 서비스 확인 '확인 필요'

cat << EOF >> $RESULT

[양호]: 불필요한 RPC 서비스가 비활성화 되어 있는 경우

[취약]: 불필요한 RPC 서비스가 활성화 되어 있는 경우


EOF

BAR

 

FILE=/etc/xinetd.conf

PERM1=600

PERM2=rw-------

FILEUSER=root

 

./check_perm.sh $FILE $PERM1 $PERM2 $FILEUSER

 

echo >>$RESULT

echo >>$RESULT