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


unnecessary_services=("rsh-server" "rlogin" "rexec")
running_services=()

for service in "${unnecessary_services[@]}"; do
    if systemctl is-active "$service" > /dev/null; then
        running_services+=($service)
    fi
done

if [ ${#running_services[@]} -gt 0 ]; then
    OK "다음 불필요한 r-패밀리 서비스가 실행 중입니다: ${running_services[@]}" | mail -s "불필요한 r-패밀리 서비스가 실행 중입니다" 
else
    WARN "불필요한 모든 r-family 서비스가 실행되고 있지 않습니다"
fi

 


 

cat $result

echo ; echo