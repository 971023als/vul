#!/bin/bash

 

. function.sh


TMP1=`SCRIPTNAME`.log

> $TMP1  

 

BAR

CODE [U-36] Apache 웹 프로세스 권한 제한 

cat << EOF >> $result

[양호]: Apache 데몬이 root 권한으로 구동되지 않는 경우

[취약]: Apache 데몬이 root 권한으로 구동되는 경우

EOF

BAR

 

# Use ps to check the process status and grep to filter the Apache process
result=$(ps -ef | grep -E 'httpd|apache2' | grep -v grep | awk '{print $1}' | grep -w "root")

if [ -n "$result" ]; then
    WARN "Apache 데몬이 루트 권한으로 실행되고 있습니다."
else
    OK "Apache 데몬이 루트 권한으로 실행되고 있지 않습니다."
fi



cat $TMP1

echo ; echo

 
