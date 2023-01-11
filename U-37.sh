#!/bin/bash

 

. function.sh

 

 

BAR

CODE [U-37] Apache 상위 디렉터리 접근 금지 

cat << EOF >> $RESULT

[양호]: 상위 디렉터리에 이동제한을 설정한 경우

[취약]: 상위 디렉터리에 이동제한을 설정하지 않은 경우

EOF

BAR

 
# Use ps to check the process status and grep to filter the Apache process
result=$(ps -ef | grep -E 'httpd|apache2' | grep -v grep | awk '{print $1}' | grep -w "root")

if [ -n "$result" ]; then
    WARN "Apache 데몬이 루트 권한으로 실행되고 있습니다."
else
    OK "Apache 데몬이 루트 권한으로 실행되고 있지 않습니다."
fi



cat $RESULT

echo ; echo

 

 

