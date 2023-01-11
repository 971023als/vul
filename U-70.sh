#!/bin/bash

 

. function.sh

 
TMP1=`SCRIPTNAME`.log

> $TMP1   
 

BAR

CODE [U-70] expn, vrfy 명령어 제한

cat << EOF >> $result

[양호]: SMTP 서비스 미사용 또는, noexpn, novrfy 옵션이 설정되어 있는 경우

[취약]: SMTP 서비스 사용하고, noexpn, novrfy 옵션이 설정되어 있지 않는 경우

EOF

BAR
 

SMTP_SERVER=smtp.example.com
SMTP_PORT=25

# Use netcat to check if SMTP service is running
nc -z -w5 $SMTP_SERVER $SMTP_PORT
if [ $? -eq 0 ]; then
    echo "SMTP service is running on $SMTP_SERVER:$SMTP_PORT"
else
    echo "SMTP service is not running on $SMTP_SERVER:$SMTP_PORT"
fi

# Check for noexpn option

if echo $(rsp) | grep -q "250-EXPN"; then
    echo "noexpn 옵션이 설정되지 않았습니다."
else
    echo "noexpn 옵션이 설정되어 있습니다."
fi

# Check for novrfy option
if echo $(rsp) | grep -q "250-VRFY"; then
    echo "novrfy 옵션이 설정되지 않았습니다."
else
    echo "novrfy 옵션이 설정되어 있습니다."
fi
    

cat $TMP1

echo ; echo 
