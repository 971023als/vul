#!/bin/bash

 

. function.sh

 

TMP1=`SCRIPTNAME`.log

> $TMP1

 

BAR

CODE [U-05] root 홈, 패스 디렉토리 권한 및 패스 설정

cat << EOF >> $result

[양호]: PATH 환경변수에 "." 이 맨 앞이나 중간에 포함되지 않은 경우

[취약]: PATH 환경변수에 "." 이 맨 앞이나 중간에 포함되어 있는 경우

EOF

BAR

 

path="$PATH"

# 경로 시작 부분에 '.'이 있는지 확인합니다
if [[ "$path" =~ ^\. ]]; then
    WARN "Dangerous  '.' 이 PATH 변수의 시작 부분에서 발견되었습니다."
fi

# 경로 중간에 '.'이 있는지 확인합니다
if [[ "$path" =~ :\. ]]; then
    WARN "Dangerous '.' 이 PATH 변수의 중간에서 발견되었습니다."
fi
OK "PATH 변수는 안전합니다.."


 

 

cat $result

echo ; echo
