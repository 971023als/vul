#!/bin/bash

 

. function.sh


TMP1=`SCRIPTNAME`.log

> $TMP1  

BAR

CODE [U-47] 패스워드 최대 사용기간 설정

cat << EOF >> $result

[양호]: 패스워드 최대 사용기간이 90일(12주) 이하로 설정되어 있는 경우

[취약]: 패스워드 최대 사용기간이 90일(12주) 이하로 설정되어 있지 않은 경우

EOF

BAR

 

 

Value=$(egrep -v '^#|^$' /etc/login.defs | grep PASS_MAX_DAYS)

CHECK_FILE=$(egrep -v '^#|^$' /etc/login.defs | grep PASS_MAX_DAYS | awk '{print $2}')

#echo $CHECK_FILE

if [ $CHECK_FILE -le 90 ] ; then

OK "패스워드 최대 사용기간이 90일(12주) 이하로 설정되어 있습니다."

else

WARN "패스워드 최대 사용기간이 90일(12주) 이하로 설정되어 있지 않습니다."

INFO $TMP1 파일을 참고 하세요.

echo "===================================================" >> $TMP1

echo "1. $LOGINDEFSFILE 파일의 내용입니다." >> $TMP1

echo "" >> $TMP1

echo $Value >> $TMP1

echo "===================================================" >> $TMP1

fi

 

 

cat $result

echo ; echo
