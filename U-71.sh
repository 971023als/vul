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

filename="/etc/apache2/apache2.conf"

if [ ! -e "$filename" ]; then
  echo "$filename does not exist."
fi

server_tokens=$(grep -i 'ServerTokens' "$filename" | awk '{print $2}')
server_signature=$(grep -i 'ServerSignature' "$filename" | awk '{print $2}')

if [ "$server_tokens" == "Prod" ]; then
  echo "The Server Tokens setting is set to Prod."
else
  echo "The Server Tokens setting is not set to Prod."
fi

if [ "$server_signature" == "Off" ]; then
  echo "The Server Signature setting is set to Off."
else
  echo "The Server Signature setting is not set to Off."
fi


cat $result

echo ; echo 