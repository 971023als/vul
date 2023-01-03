#!/bin/bash

 

. function.sh

 

TMP1=./log/`SCRIPTNAME`.log

> $TMP1

 

BAR

CODE [U-15] world writable 파일 점검

cat << EOF >> $RESULT

[양호]: world writable 파일이 존재하지 않거나, 존재 시 설정 이유를 확인하고 있는 경우

[취약]: world writable 파일이 존재하나 해당 설정 이유를 확인하고 있지 않은 경우

EOF

BAR

 

TMP2=$(mktemp)

 

find / -perm -2 -ls 2>/dev/null | egrep -v '(/proc|lrwx|/tmp)' >$TMP2

 

cat $TMP2 | while read INUM1 NUM1 PERM1 OTHER

do

echo $PERM1 | egrep -v '(^s|^d|^c|^b|t$)' > /dev/null 2>&1

if [ $? -eq 0 ] ; then

echo $PERM1 $OTHER >> $TMP1

fi

done

 

if [ -s $TMP1 ] ; then

WARN world writable 파일이 존재합니다.

INFO $TMP1을 확인하십시오.

else

OK world writable 파일이 존재하지 않습니다.

fi

 

echo >>$RESULT

echo >>$RESULT

 
