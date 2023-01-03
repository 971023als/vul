#!/bin/bash

 

. function.sh

 

 

BAR

CODE [U-58] 홈 디렉터리로 지정한 디렉터리의 존재 관리 

cat << EOF >> $RESULT

[양호]: 홈 디렉터리가 존재하지 않는 계정이 발견되지 않는 경우

[취약]: 홈 디렉터리가 존재하지 않는 계정이 발견된 경우

EOF

BAR

 

TMP1=$(mktemp)

FILE1=/etc/passwd

TRUEFALSE=1

 

cat /etc/passwd | awk -F: '$3 >= 500 && $3 <60000 {print $1,$6}' > $TMP1

 

cat $TMP1 | while read USERNAME HOMEDIR

do

if [ -z $HOMEDIR ] ; then

WARN $HOMENAME 의 홈디렉터리가 존재하지 않습니다. 

TRUEFALSE=0

fi

if [ $HOMEDIR == '/' ] ; then

WARN $HOMENAME 의 홈디렉터리가 /로 설정되어 있습니다.

TRUEFALSEs=0

fi

done

 

if [ $TRUEFALSE -eq 1 ] ; then

OK 사용자의 홈디렉터리 설정이 양호합니다. 

fi

 

echo >>$RESULT

echo >>$RESULT
