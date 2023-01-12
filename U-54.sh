#!/bin/bash

 

. function.sh

 

TMP1=`SCRIPTNAME`.log

> $TMP1

 

BAR

CODE [U-54] Session Timeout 설정

cat << EOF >> $result

[양호]: Session Timeout이 600초(10분) 이하로 설정되어 있는 경우

[취약]: Session Timeout이 600초(10분) 이하로 설정되지 않은 경우

EOF

BAR



timeout=`grep -i "session.timeout" /path/to/config/file`

if [[ $timeout -le 600 ]]; then
  WARN "세션 시간 초과가 $timeout seconds로 설정되었으며, 이는 허용 가능합니다."
else
  OK "세션 시간 초과가 $timeout seconds로 설정되었습니다. 이는 너무 깁니다. 10분 이내로 조정해 주세요."
fi


cat $result

echo ; echo
