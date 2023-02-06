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


# /etc/login.defs에서 최소 암호 길이 확인
min_len_defs=$(grep "^PASS_MIN_LEN" /etc/login.defs | awk '{print $2}')
if [ "$(expr "$min_len_defs" + 0)" -ge 8 ]; then
  OK "/etc/login.defs의 최소 암호 길이가 $min_len_defs 로 설정됨"
else
  WARN "/etc/login.defs의 최소 암호 길이가 8보다 작음"
fi

# /etc/pam.d/system-auth에서 영어, 숫자 및 특수 문자 설정 확인
min_len_pam=$(grep "pam_cracklib.so" /etc/pam.d/system-auth | grep "minlen" | awk -F"=" '{print $2}')
if [ "$(expr "$min_len_pam" + 0)" -ge 8 ]; then
  OK "/etc/pam.d/system-auth의 최소 암호 길이가 $min_len_pam으로 설정됨"
else
  WARN "/etc/pam.d/system-auth의 최소 암호 길이가 8보다 작습니다."
fi


 

cat $result

echo ; echo
