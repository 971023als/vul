#!/bin/bash

 

. function.sh

 



 

BAR

CODE [U-13] SUID,SGID,Sticky bit 설정파일 점검 

cat << EOF >> $RESULT

[양호]: 주요 파일의 권한에 SUID와 SGID에 대한 설정이 부여되어 있지 않은 경우

[취약]: 주요 파일의 권한에 SUID와 SGID에 대한 설정이 부여되어 있는 경우

EOF

BAR

 

cat $LOG | while read PERM FILENAME2

do

if [ `echo $PERM | egrep '(s|t)' >/dev/null` ]; then

echo PASS $FILENAME2은 특수 권한이 설정되어 있습니다.

else

echo NOT $FILENAME2은 특수 권한이 설정되어 있지 않습니다.



echo >>$RESULT

echo >>$RESULT

 
