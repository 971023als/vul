#!/bin/bash 

. function.sh

BAR

CODE [U-02] 패스워드 복잡성 설정

cat << EOF >> $result

[양호]: 영문 숫자 특수문자가 혼합된 8 글자 이상의 패스워드가 설정된 경우.

[취약]: 영문 숫자 특수문자 혼합되지 않은 8 글자 미만의 패스워드가 설정된 경우.

EOF

BAR

TMP1=`SCRIPTNAME`.log

>$TMP1 

# login.defs 파일에서 PASS_MAX_DAYS 값을 가져옵니다
pass_min_len=$(grep -E "^PASS_MIN_LEN" /etc/login.defs | awk '{print $2}')

min=8

# PASS_MIN_LEN 값이 주석 처리되었는지 확인합니다
if grep -q "^#PASS_MIN_LEN" /etc/login.defs; then
  INFO "PASS_MIN_LEN가 주석 처리되었습니다."
else
    # PASS_MIN_LEN의 값이 지정된 범위 내에 있는지 확인합니다
    if [ "$pass_min_len" -ge 0 ] && [ "$pass_min_len" -le 99999999 ]; then
      if [ "$pass_min_len" -le "$min" ]; then
        WARN "8 글자 미만의 패스워드가 설정."
      else
        OK "8 글자 이상의 패스워드가 설정."
      fi
    else
      INFO "PASS_MIN_LEN 값이 범위를 벗어났습니다."
    fi
fi



PAM_FILE="/etc/pam.d/common-auth"
EXPECTED_OPTIONS="password requisite pam_cracklib.so try_first_pass restry=3 minlen=8 lcredit=-1 ucredit=-1 dcredit=-1 ocredit=-1"


if [ -f "$PAM_FILE" ]; then
    if grep -q "$EXPECTED_OPTIONS" "$PAM_FILE" ; then
        OK " $PAM_FILE 에 $EXPECTED_OPTIONS 있음  "
    else
        WARN " $PAM_FILE 에 $EXPECTED_OPTIONS 없음  "
    fi
else
    INFO " $PAM_FILE 못 찾음"
fi

cat $result

echo ; echo
