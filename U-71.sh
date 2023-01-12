#!/bin/bash

 

. function.sh

 
TMP1=`SCRIPTNAME`.log

> $TMP1 
 

BAR

CODE [U-71] Apache 웹서비스 정보 숨김

cat << EOF >> $result

[양호]: ServerTokens 지시자에 Prod 옵션이 설정되어 있는 경우

[취약]: ServerTokens 지시자에 Prod 옵션이 설정되어 있지 않는 경우

EOF

BAR



cat $result

echo ; echo 