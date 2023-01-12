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


# Check if the noexpn option is not set
result="telnet localhost 25 << EOF
expn root
EOF"
if [[ $result == *"252"* ]]; then
  WARN "noexpn 옵션이 설정되지 않았습니다."
else
  OK "noexpn 옵션이 설정되었습니다."
fi

# Check if the novrfy option is not set
result="telnet localhost 25 << EOF
vrfy root
EOF"
if [[ $result == *"252"* ]]; then
  WARN "novrfy 옵션이 설정되지 않았습니다."
else
  OK "novrfy 옵션이 설정되었습니다."
fi


    

cat $result

echo ; echo 
