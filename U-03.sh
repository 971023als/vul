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


#  잠금 임계값 설정
lock_threshold=5

# pam_taly2 모듈이 설치되어 있는지 확인하십시오
if ! command -v pam_tally2 >/dev/null 2>&1; then
  INFO "pam_tally2 모듈이 설치되지 않았습니다. 설치해 주세요."
fi

# /etc/pam.d/common-auth 파일에서 계정 잠금 임계값을 가져옵니다
current_threshold=$(grep "auth required pam_tally2.so" /etc/pam.d/common-auth | awk '{print $6}' | sed 's/deny=//g')

# 잠금 임계값 비교
if [ "$lock_threshold" -ne "$current_threshold" ]; then
  WARN "계정 잠금 임계값이 $lock_threshold로 설정되지 않았습니다. 현재 값은 $current_threshold입니다."
else
  OK "계정 잠금 임계값이 $lock_threshold로 설정되었습니다."
fi

# 계정 잠금 임계값을 가져옵니다
threshold=$(grep "^auth[[:space:]]*required[[:space:]]*pam_tally2.so.*" /etc/pam.d/common-auth | awk '{print $NF}')

# 임계값이 10보다 작거나 같은지 점검하십시오
if [[ $threshold -le 10 ]]; then
  OK "계정 잠금 임계값이 10보다 작거나 같은 $threshold로 설정되었습니다."
  INFo "제대로 된 보안 설정이 아닙니다. 임계값을 늘리는 것을 고려하십시오."
else
  WARN "계정 잠금 임계값이 10보다 큰 $threshold로 설정되었습니다."
fi



cat $result

echo ; echo
