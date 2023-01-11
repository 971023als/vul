#!/bin/bash

 

. function.sh

TMP1=`SCRIPTNAME`.log

> $TMP1

 

BAR

CODE [U-44] root 이외의 UID가 '0' 금지

cat << EOF >> $U44

[양호]: root 계정과 동일한 UID를 갖는 계정이 존재하지 않는 경우

[취약]: root 계정과 동일한 UID를 갖는 계정이 존재하는 경우

EOF

BAR

 

PASSFILE=passwd

awk -F: '$3 == "0" {print $1}' $PASSFILE >> $TMP1

UIDZEROCNT=$(wc -l < $TMP1)

if [ $UIDZEROCNT -ge 2 ] ; then

WARN 'root 계정과 동일한 UID를 갖는 계정이 존재합니다'

INFO $TMP1 참고 하십시오

else

OK 'root 계정과 동일한 UID를 갖는 계정은 없습니다.'

fi

 

cat $U44

echo ; echo
