#!/bin/bash

 

. function.sh

 
TMP1=`SCRIPTNAME`.log

> $TMP1  
 

BAR

CODE [U-60] ssh 원격접속 허용

cat << EOF >> $result

[양호]: 원격 접속 시 SSH 프로토콜을 사용하는 경우

[취약]: 원격 접속 시 Telnet, FTP 등 안전하지 않은 프로토콜을 사용하는 경우

EOF

BAR

# 활성 연결 가져오기
connections=$(ss -t -a | awk '{print $5}')

# 포트 22(SSH)를 사용하는 연결부가 있는지 점검하십시오
if [[ $connections =~ :22 ]]; then
  OK "SSH 프로토콜이 원격 연결에 사용되고 있습니다."
else
  WARN "SSH 프로토콜을 사용하는 연결이 검색되지 않음"
fi


cat $result

echo ; echo 
