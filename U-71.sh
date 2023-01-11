#!/bin/bash

 

. function.sh

 

 

BAR

CODE [U-71] Apache 웹서비스 정보 숨김

cat << EOF >> $U71

[양호]: ServerTokens 지시자에 Prod 옵션이 설정되어 있는 경우

[취약]: ServerTokens 지시자에 Prod 옵션이 설정되어 있지 않는 경우

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

cat $U71

echo ; echo 