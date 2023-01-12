#!/bin/bash

 

. function.sh

TMP1=`SCRIPTNAME`.log

> $TMP1

 

BAR

CODE [U-03] 계정 잠금 임계값 설정

cat << EOF >> $result

[양호]: 계정 잠금 임계값이 10회 이하의 값으로 설정되어 있는 경우

[취약]: 계정 잠금 임계값이 설정되어 있지 않거나, 10회 이하의 값으로 설정되지 않은 경우

EOF

BAR


# Check if account lock threshold is set in /etc/pam.d/common-auth
if ! grep -q "auth required pam_tally2.so" /etc/pam.d/common-auth; then
    WARN "계정 잠금 임계값이 /etc/pam.d/common-auth에서 설정되지 않았습니다."
else
    # Check if account lock threshold is less than 10
    if grep -q "auth required pam_tally2.so deny=10" /etc/pam.d/common-auth; then
        WARN "계정 잠금 임계값이 10 미만으로 설정됨"
    fi
fi
OK "계정 잠금 임계값이 10회 이하의 값으로 설정됩니다."



cat $result

echo ; echo
