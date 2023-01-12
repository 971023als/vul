#!/bin/bash

. function.sh

TMP1=`SCRIPTNAME`.log

> $TMP1

BAR

CODE [U-23] DoS 공격에 취약한 서비스 비활성화

cat << EOF >> $result

[ 양호 ] : DoS 공격에 취약한 echo, discard, daytime, chargen 서비스가 비활성화 된 경우

[ 취약 ] : DoS 공격에 취약한 echo, discard, daytime, chargen 서비스 활성화 된 경우

EOF

BAR


vulnerable_services=("echo-dgram" "echo-stream" "chargen-dgram" "chargen-stream")
running_services=()

for service in "${vulnerable_services[@]}"; do
    if systemctl is-active "$service" > /dev/null; then
        running_services+=($service)
    elif systemctl is-enabled "$service" > /dev/null; then
        running_services+=($service)
    fi
done

if [ ${#running_services[@]} -gt 0 ]; then
    WARN "다음 취약한 서비스가 실행 중이거나 사용하도록 설정되었습니다. ${running_services[@]}" | mail -s "Vulnerable services running or enabled" 
else
    OK "모든 취약한 서비스가 실행되고 있지 않거나 사용하도록 설정되어 있지 않습니다."
fi


cat $result

echo ; echo