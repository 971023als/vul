#!/bin/bash

 

. function.sh

 
TMP1=`SCRIPTNAME`.log

> $TMP1 
 

BAR

CODE [U-71] Apache 웹서비스 정보 숨김

cat << EOF >> $result

[양호]: ServerTokens Prod, ServerSignature Off로 설정되어있는 경우

[취약]: ServerTokens Prod, ServerSignature Off로 설정되어있지 않은 경우

EOF

BAR

# Check if Server Tokens is set to "Prod"
result=`grep "ServerTokens" /etc/httpd/conf/httpd.conf`
if [[ $result == *"Prod"* ]]; then
  OK "Server Tokens이 Prod로 설정됨"
else
  WARN "Server Tokens이 Prod로 설정되지 않음"
fi

# Check if Server Signature is set to "Off"
result=`grep "ServerSignature" /etc/httpd/conf/httpd.conf`
if [[ $result == *"Off"* ]]; then
  OK "Server Signature가 Off로 설정됨"
else
  WARN "Server Signature가 Off로 설정되어 있지 않음"
fi


cat $result

echo ; echo 