#!/bin/bash

 

. function.sh

TMP1=`SCRIPTNAME`.log

> $TMP1   

 

BAR

CODE [U-34] DNS Zone Transfer 설정

cat << EOF >> $result

[양호]: DNS 서비스 미사용 또는, Zone Transfer를 허가된 사용자에게만 허용한 경우

[취약]: DNS 서비스를 사용하여 Zone Transfer를 모든 사용자에게 허용한 경우

EOF

BAR

# dig 명령이 설치되어 있는지 확인하십시오
if ! command -v dig >/dev/null 2>&1; then
    INFO "'dig' 명령이 설치되지 않았습니다. 계속하기 전에 설치하십시오."
fi

# 로컬 해결사가 작동 중인지 확인하십시오
INFO "로컬 확인 중..."
if dig +short localhost >/dev/null 2>&1; then
    WARN "로컬 해결사가 작동 중입니다."
else
    OK "로컬 해결사가 작동하지 않습니다. DNS 구성을 확인하십시오."
fi

# 공용 DNS 서버가 작동 중인지 확인
INFO "공용 DNS 서버 확인 중..."
if dig +short google.com >/dev/null 2>&1; then
    WARN "공용 DNS 서버가 작동 중입니다."
else
    OK "공용 DNS 서버가 작동하지 않습니다. 인터넷 연결 또는 DNS 구성을 확인하십시오."
fi

# 모든 검사 통과
INFO "DNS 서비스가 예상대로 작동하고 있습니다."



cat $result

echo ; echo