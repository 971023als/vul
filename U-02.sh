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

LOGIN_DEFS_FILE="/etc/login.defs"
PASS_MIN_LEN_OPTION="PASS_MIN_LEN"

if [ ! -f "$LOGIN_DEFS_FILE" ]; then
    WARN "$LOGIN_DEFS_FILE 을 찾을 수 없습니다."
else
    PASS_MIN_LEN=$(grep "^$PASS_MIN_LEN_OPTION" "$LOGIN_DEFS_FILE" | awk '{print $2}')

    if [ -z "$PASS_MIN_LEN" ]; then
        WARN "$LOGIN_DEFS_FILE 에서 $PASS_MIN_LEN_OPTION 을 찾을 수 없습니다."
    elif [ "$PASS_MIN_LEN" -lt 8 ]; then
        WARN "$LOGIN_DEFS_FILE 에서 $PASS_MIN_LEN_OPTION 값이 8보다 작습니다."
    else
        OK "$LOGIN_DEFS_FILE 에서 $PASS_MIN_LEN_OPTION 값이 8 이상입니다."
    fi
fi

PAM_FILE="/etc/pam.d/common-auth"
EXPECTED_OPTIONS="retry=3 minlen=8 lcredit=-1 ucredit=-1 dcredit=-1 ocredit=-1"

if [ ! -f "$PAM_FILE" ]; then
    WARN "$PAM_FILE  찾을 수 없습니다."
else
    OPTIONS=$(grep "pam_cracklib.so" "$PAM_FILE" | awk '{print $NF}')

    if [ "$OPTIONS" == "$EXPECTED_OPTIONS" ]; then
        OK "옵션이 $PAM_FILE의 예상 값과 일치합니다."
    else
        WARN "옵션이 $PAM_FILE의 예상 값과 일치하지 않습니다."
    fi
fi


 

cat $result

echo ; echo
