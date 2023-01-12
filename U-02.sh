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


# Check for minimum password length
min_length=$(grep "^password.*sufficient.*pam_unix.so.*minlen" /etc/pam.d/common-password | awk '{print $9}')
if [ $min_length -lt 8 ]; then
    WARN "최소 암호 길이가 8자 미만입니다."
fi

# Check for minimum input of special characters, digits, and letters
cracklib=$(grep "^password.*sufficient.*pam_cracklib.so.*difok" /etc/pam.d/common-password | awk '{print $9}')
if [ $cracklib -lt 3 ]; then
    WARN "특수 문자, 숫자 및 문자의 최소 입력이 3 미만입니다."
fi
OK "비밀번호 정책은 최소 길이 8자, 영문, 숫자, 특수 문자 입력으로 설정됩니다."


 

cat $result

echo ; echo
