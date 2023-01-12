#!/bin/bash

 

. function.sh

TMP1=`SCRIPTNAME`.log

> $TMP1

 

BAR

CODE [U-03] 계정 잠금 임계값 설정

cat << EOF >> $result

[양호]: 계정 잠금 임계값이 5이하의 값으로 설정되어 있는 경우

[취약]: 계정 잠금 임계값이 설정되어 있지 않거나, 5이하의 값으로 설정되지 않은 경우

EOF

BAR


# Check if the pam_tally2 module is in use
if ! grep -q "pam_tally2" /etc/pam.d/common-auth; then
    INFO "https_https2 모듈이 사용 중이 아닙니다."
elif grep -q "^auth.*required.*pam_tally2.so.*onerr=fail.*deny=5" /etc/pam.d/common-auth; then
    ok "계정 잠금 임계값이 5회로 설정되었습니다."
else
    WARN "계정 잠금 임계값이 설정되지 않았거나 5보다 큰 값으로 설정되지 않았습니다."
fi



 

cat $result

echo ; echo
