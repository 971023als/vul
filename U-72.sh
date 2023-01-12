#!/bin/bash

 

. function.sh

 
TMP1=`SCRIPTNAME`.log

> $TMP1 
 

BAR

CODE [U-72] 정책에 따른 시스템 로깅 설정

cat << EOF >> $result

[양호]: 로그 기록 정책이 정책에 따라 설정되어 수립되어 있는 경우

[취약]: 로그 기록 정책이 정책에 따라 설정되어 수립되어 있지 않은 경우

EOF

BAR


# Check if any logging policy has been established
result=`cat /etc/rsyslog.conf`
if [[ $result == *"log"* ]]; then
  OK "로깅 정책이 설정되었습니다."
else
  WARN "로깅 정책이 설정되지 않았습니다."
fi

# Check if any security policy has been set
result=`cat /etc/security/limits.conf`
result2=`cat /etc/pam.d/common-*`
if [[ $result == *"security"* || $result2 == *"security"* ]]; then
  OK "보안 정책이 설정되었습니다"
else
  WARN "보안 정책이 설정되자 않았습니다"
fi

# Check if any security policy leaves a log
result=`cat /etc/rsyslog.conf`
if [[ $result == *"security"* ]]; then
  OK "보안 정책이 로그를 남깁니다"
else
  WARN "로그를 남기는 보안 정책 없습니다."
fi



cat $result

echo ; echo 

 
