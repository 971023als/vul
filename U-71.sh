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

# 서버 토큰이 "Prod"로 설정되어 있는지 확인하십시오
ServerTokens=`grep "ServerTokens" /etc/apache2/apache2.conf`
if [[ $ServerTokens == *"Prod"* ]]; then
  OK "Server Tokens이 Prod로 설정됨"
else
  WARN "Server Tokens이 Prod로 설정되지 않음"
fi

# 서버 서명이 "끄기"로 설정되어 있는지 확인합니다
ServerSignature=`grep "ServerSignature" /etc/apache2/apache2.conf`
if [[ $ServerSignature == *"Off"* ]]; then
  OK "Server Signature가 Off로 설정됨"
else
  WARN "Server Signature가 Off로 설정되어 있지 않음"
fi


cat $result

echo ; echo 