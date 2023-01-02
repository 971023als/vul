#!/bin/bash

 

. function.sh

 

TMP1=./log/`SCRIPTNAME`.log

> $TMP1

 

BAR

CODE [U-24] SUID,SGID,Sticky bit 설정파일 점검 

cat << EOF >> $RESULT

[양호]: 주요 파일의 권한에 SUID와 SGID에 대한 설정이 부여되어 있지 않은 경우

[취약]: 주요 파일의 권한에 SUID와 SGID에 대한 설정이 부여되어 있는 경우

EOF

BAR

 

find / -xdev -user root -type f -perm -4000 -o -perm -2000 -exec ls -al {} \; > $TMP1

 

INFO $TMP1 를 확인하십시오. 

 

echo >>$RESULT

echo >>$RESULT

 
