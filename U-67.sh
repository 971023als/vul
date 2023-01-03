#!/bin/bash

 

. function.sh

 

BAR

CODE [U-67] SNMP 서비스 Community String의 복잡성 설정

cat << EOF >> $RESULT

[양호]: SNMP Community 이름이 public, private 이 아닌 경우

[취약]: SNMP Community 이름이 public, private 인 경우

EOF

BAR

 

FILE=/etc/snmp/snmpd.conf

TMP=$(mktemp)

 

ps -ef | grep snmp | grep -v grep >/dev/null 2>&1

 

if [ $? -eq 0 ] ; then

cat $FILE | grep com2sec | grep -v '^#' \

| egrep 'default|private' >/dev/null 2>&1

if [ $? -eq 0 ] ; then

WARN SNMP Community 이름이 public, private로 설정되어 있습니다.

INFO $FILE에서 Comunity를 변경하십시오.

else

OK SNMP Community 이름의 설정이 양호합니다. 

fi

else

OK SNMP 서비스를 사용하지 않고 있습니다.

fi

 

echo >>$RESULT

echo >>$RESULT
