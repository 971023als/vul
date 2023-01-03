#!/bin/bash

 

. function.sh

 

 

BAR

CODE [U-55] hosts.lpd 파일 소유자 및 권한 설정

cat << EOF >> $RESULT

[양호]: 파일의 소유자가 root 이고 Other에 쓰기 권한이 부여되어 있지 않는 경우

[취약]: 파일의 소유자가 root가 아니고 Other에 쓰기 권한이 부여되어 있는 경우

EOF

BAR

 

FILE=/etc/hosts.lpd

PERM1=600

PERM2=rw-------

FILEUSER=root

 

./check_perm.sh $FILE $PERM1 $PERM2 $FILEUSER

 

echo >>$RESULT

echo >>$RESULT
