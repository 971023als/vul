#!/bin/bash

 

. function.sh

 

BAR

CODE [U-10] /etc/xinetd.conf 파일 소유자 및 권한 설정 

cat << EOF >> $RESULT

[양호]: /etc/xinetd.conf 파일의 소유자가 root이고, 권한이 600인 경우

[취약]: /etc/xinetd.conf 파일의 소유자가 root가 아니거나, 권한이 600이 아닌경우

EOF

BAR

 

FILE=/etc/xinetd.conf

PERM1=600

PERM2=rw-------

FILEUSER=root

 

. check_perm.sh $FILE $PERM1 $PERM2 $FILEUSER

 

echo >>$RESULT

echo >>$RESULT

 
