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


# Get the current account lock threshold
threshold=$(grep "^auth.*pam_tally2.so.*onerr=fail.*silent.*deny=.*lock_time=" /etc/pam.d/common-auth | awk '{print $9}' | awk -F "=" '{print $2}')

# Check if the threshold is not set
if [ -z "$threshold" ]; then
  WARN "Error: 계정 잠금 임계값이 설정되지 않았습니다"
fi

# Check if the threshold is greater than 10
if [ "$threshold" -gt 10 ]; then
  WARN "Error: 계정 잠금 임계값이 $threshold로 설정되었습니다. 10 이하여야 합니다"
fi

# If the script reaches this point, the threshold is set to a value of 10 or less
OK "계정 잠금 임계값이 $threshold(필요에 따라 10 이하)로 설정되었습니다."




 

cat $result

echo ; echo
