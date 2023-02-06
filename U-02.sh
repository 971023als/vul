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
if [ "$min_len_defs" -eq "$min_len_defs" ] 2>/dev/null; then
  if [ "$(expr "$min_len_defs" + 0)" -ge 8 ]; then
    OK "/etc/login.defs의 최소 암호 길이가 $min_len_defs 로 설정됨"
  else
    WARN "/etc/login.defs의 최소 암호 길이가 8보다 작음"
fi

# 파일이 있는지 확인하십시오
if [ -f /etc/pam.d/system-auth ]; then
  # 최소 대문자 수가 설정되어 있는지 확인하십시오
  min_ucase=$(grep "pam_cracklib.so" /etc/pam.d/system-auth | grep "ucredit" | awk -F"=" '{print $2}')
  if [ "$(expr "$min_ucase" + 0)" -ge 1 ]; then
    OK "최소 대문자 수가 설정되었습니다."
  else
    WARN "최소 대문자 수가 설정되지 않았거나 1보다 작습니다."
  fi

  # 최소 소문자 수가 설정되어 있는지 확인하십시오
  min_lcase=$(grep "pam_cracklib.so" /etc/pam.d/system-auth | grep "lcredit" | awk -F"=" '{print $2}')
  if [ "$(expr "$min_lcase" + 0)" -ge 1 ]; then
    OK "소문자의 최소 수가 설정되었습니다."
  else
    WARN "소문자의 최소 수가 설정되지 않았거나 1자 미만입니다."
  fi

  # 최소 숫자 문자 수가 설정되어 있는지 확인합니다
  min_num=$(grep "pam_cracklib.so" /etc/pam.d/system-auth | grep "dcredit" | awk -F"=" '{print $2}')
  if [ "$(expr "$min_num" + 0)" -ge 1 ]; then
    OK "최소 숫자 문자 수가 설정되었습니다."
  else
    WARN "최소 숫자 문자 수가 설정되지 않았거나 1보다 작습니다."
  fi

  # 최소 특수 문자 수가 설정되어 있는지 확인하십시오
  min_spec=$(grep "pam_cracklib.so" /etc/pam.d/system-auth | grep "ocredit" | awk -F"=" '{print $2}')
  if [ "$(expr "$min_spec" + 0)" -ge 1 ]; then
    OK "최소 특수 문자 수가 설정되었습니다."
  else
    WARN "최소 특수 문자 수가 설정되지 않았거나 1보다 작습니다."
  fi
else
  INFO "/etc/pam.d/system-auth 파일이 없습니다."
fi


 

cat $result

echo ; echo
