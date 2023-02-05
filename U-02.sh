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


# Check minimum password length in /etc/login.defs
min_len_defs=$(grep "^PASS_MIN_LEN" /etc/login.defs | awk '{print $2}')
if [ "$min_len_defs" -ge 8 ]; then
  echo "Minimum password length in /etc/login.defs is set to $min_len_defs"
else
  echo "Minimum password length in /etc/login.defs is less than 8"
fi

# Check for minimum input of English, numeric, and special characters in /etc/pam.d/system-auth
min_len_pam=$(grep "pam_cracklib.so" /etc/pam.d/system-auth | grep "minlen" | awk -F"=" '{print $2}')
if [ "$min_len_pam" -ge 8 ]; then
  echo "Minimum password length in /etc/pam.d/system-auth is set to $min_len_pam"
else
  echo "Minimum password length in /etc/pam.d/system-auth is less than 8"
fi


 

cat $result

echo ; echo
