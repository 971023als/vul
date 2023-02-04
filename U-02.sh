#!/bin/bash 

 

. function.sh

 

TMP1=$(SCRIPTNAME).log

> $TMP1

 
BAR

CODE [U-02] 패스워드 복잡성 설정

cat << EOF >> $result

[양호]: 영문 숫자 특수문자가 혼합된 8 글자 이상의 패스워드가 설정된 경우.

[취약]: 영문 숫자 특수문자 혼합되지 않은 8 글자 미만의 패스워드가 설정된 경우.

EOF

BAR

min_len=$(grep "^PASS_MIN_LEN" /etc/login.defs | awk '{print $2}')

if [ "$min_len" -lt 8 ]; then
  OK "최소 암호 길이가 8자 미만입니다."
  
else
  WARN "최소 암호 길이는 8자 이상인 $min_len 문자로 설정됩니다."
fi

grep -q "^password.*required.*pam_cracklib.so.*minclass=3" /etc/pam.d/system-auth

if [ $? -ne 0 ]; then
  OK "/etc/pam.d/system-auth에 암호에 대한 최소 문자 요구 사항이 설정되지 않았습니다."
else
  WARN "/etc/pam.d/system-auth에서 설정된 암호에 대한 최소 문자 요구 사항 설정 완료."
fi

 

cat $result

echo ; echo
