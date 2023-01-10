#!/bin/bash

 

. function.sh

 

BAR

CODE [U-12] /etc/services 파일 소유자 및 권한 설정 

cat << EOF >> $RESULT

[양호]: /etc/services 파일의 소유자가 root이고, 권한이 644인 경우

[취약]: /etc/services 파일의 소유자가 root가 아니거나, 권한이 644가 아닌경우

EOF

BAR

 

FILE=/etc/services

PERM1=644

PERM2=rw-r--r--

FILEUSER=root

 



 

echo >>$RESULT

echo >>$RESULT
