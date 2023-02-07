#!/bin/bash

 

. function.sh

TMP1=`SCRIPTNAME`.log

> $TMP1  

BAR

CODE [U-33]  DNS 보안 버전 패치 

cat << EOF >> $result 

[양호]: DNS 서비스를 사용하지 않거나 주기적으로 패치를 관리하고 있는 경우

[취약]: DNS 서비스를 사용하며 주기적으로 패치를 관리하고 있지 않는 경우

EOF

BAR

# ps-ef | grep 명명된 명령의 출력을 변수에 저장합니다
result=$(ps -ef | grep named)

# 결과가 비어 있지 않은지 확인하십시오
if [ -n "$result" ]; then
  WARN "DNS 서비스가 실행 중"
else
  OK "DNS 서비스가 실행되고 있지 않습니다."
fi




cat $result

echo ; echo