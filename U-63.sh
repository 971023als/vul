#!/bin/bash

 

. function.sh

 

 

BAR

CODE [U-63] ftpusers 파일 소유자 및 권한 설정

cat << EOF >> $RESULT

[양호]: ftpusers 파일의 소유자가 root이고, 권한이 640 이하인 경우

[취약]: ftpusers 파일의 소유자가 root아니거나, 권한이 640 이하가 아닌 경우

EOF

BAR

 

FILE=/etc/vsftpd/ftpusers

PERM1=644

PERM2=rw-r--r--

FILEUSER=root

 

 

./check_perm.sh $FILE $PERM1 $PERM2 $FILEUSER

 

echo >>$RESULT

echo >>$RESULT

 
