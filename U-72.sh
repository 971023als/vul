#!/bin/bash

 

. function.sh

 

 

BAR

CODE [U-72] 정책에 따른 시스템 로깅 설정

cat << EOF >> $RESULT

[양호]: 로그 기록 정책이 정책에 따라 설정되어 수립되어 있는 경우

[취약]: 로그 기록 정책이 정책에 따라 설정되어 수립되어 있지 않은 경우

EOF

BAR

 

# Check Server Tokens setting
if grep -q "ServerTokens Prod" /etc/apache2/conf-enabled/security.conf; then
    OK "서버 토큰 설정이 Prod로 설정되어 있습니다."
else
    WARN "서버 토큰 설정이 Prod로 설정이 안 되어 있습니다"
fi

# Check Server Signature setting
if grep -q "ServerSignature Off" /etc/apache2/conf-enabled/security.conf; then
    OK "Server Signature 설정이 Off로 설정되어 있습니다"
else
    WARN "Server Signature 설정이 Off로 설정이 안 되어 있습니다"
fi

cat $RESULT

echo ; echo 

 
