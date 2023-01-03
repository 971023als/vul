#!/bin/bash

 

. function.sh

 

BAR

CODE [U-11] /etc/syslog.conf 파일 소유자 및 권한 설정 

cat << EOF >> $RESULT

[양호]: /etc/syslog.conf 파일의 소유자가 root이고, 권한이 644인 경우

[취약]: /etc/syslog.conf 파일의 소유자가 root가 아니거나, 권한이 644가 아닌경우

EOF

BAR

 

 

FILE=/etc/syslog.conf

PERM1=644

PERM2=rw-r--r--

FILEUSER=root

 

./check_perm.sh $FILE $PERM1 $PERM2 $FILEUSER

 

echo >>$RESULT

echo >>$RESULT

 
