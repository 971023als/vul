#!/bin/bash

 

. function.sh

 

TMP1=`SCRIPTNAME`.log

> $TMP1

TMP2=/tmp/tmp2

> $TMP2

 

BAR

CODE [U-21] r 계열 서비스 비활성화

cat << EOF >> $result

[양호]: r 계열 서비스가 비활성화 되어 있는 경우

[취약]: r 계열 서비스가 활성화 되어 있는 경우

EOF

BAR


# rlogin 서비스가 사용하도록 설정되었는지 확인하십시오
if [ "$(service is-enabled rlogin)" = "enabled" ]; then
  WARN "rlogin 서비스가 활성화되었습니다"
else
  OK "rlogin 서비스가 비활성화되었습니다."
fi

# rsh 서비스가 사용하도록 설정되었는지 확인하십시오
if [ "$(service is-enabled rsh)" = "enabled" ]; then
  WARN "rsh 서비스가 활성화되었습니다"
else
  OK "rsh 서비스가 비활성화되었습니다"
fi

# exec 서비스가 활성화되었는지 확인하십시오
if [ "$(service is-enabled exec)" = "enabled" ]; then
  WARN "exec 서비스 사용"
else
  OK "exec 서비스가 비활성화됨"
fi 

cat $result

echo ; echo