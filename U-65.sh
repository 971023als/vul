#!/bin/bash

 

. function.sh

 

 

BAR

CODE [U-65] at 파일 소유자 및 권한 설정

cat << EOF >> $RESULT

[양호]: at 접근제어 파일의 소유자가 root이고, 권한이 640 이하인 경우

[취약]: at 접근제어 파일의 소유자가 root가 아니거나, 권한이 640 이하가 아닌 경우

EOF

BAR

 

FILE1=/etc/at.allow

FILE2=/etc/at.deny

PERM1=640

PERM2=rw-r-----

FILEUSER=root

 

ls -l $FILE1 >/dev/null 2>&1

 

if [ $? -eq 0 ] ; then

./check_perm.sh $FILE1 $PERM1 $PERM2 $FILEUSER

else

WARN $FILE1이 없습니다.

fi

 

ls -l $FILE2 >/dev/null 2>&1

 

if [ $? -eq 0 ] ; then

./check_perm.sh $FILE2 $PERM1 $PERM2 $FILEUSER

else

WARN $FILE2가 없습니다. 

fi

 

echo >>$RESULT

echo >>$RESULT
