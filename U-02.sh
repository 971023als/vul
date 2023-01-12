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

 

 

INFO $TMP1 파일을 점검한다

echo >> $TMP1

echo

echo "다음은 /etc/login.defs 파일을 해석할 때 사용하는 내용입니다"

echo "=============================================================">> $TMP1

cat /etc/login.defs | egrep -v '(^$|^#)' >> $TMP1

 

 

cat << EOF >> $TMP1

=============================================================

다음은 /etc/login.defs 파일을 해석할 때 사용하는 내용입니다.

 

minlen : 패스워드 최소 길이입니다.

minclass : 패스워드 class 지정입니다.

lcredit : 패스워드 소문자 포함 지정입니다.

ucredit : 패스워드 대문자 포함 지정입니다.

dcredit : 패스워드 숫자 포함 지정입니다.

ocredit : 패스워드 특수문자 포함 지정입니다.

=============================================================

다음은 /etc/login.defs 파일의 내용이 없으면,

 

1) 기본값을 사용하는 경우입니다. 이 경우, 패스워드 정책에 맞지 않습니다. 

따라서, 반드시 정책을 변경할 것을 권장합니다.

2) 정책을 변경하는 경우에는 다음과 같은 명령어를 통해 설정할 수 있습니다.

# authconfig --passminlen=8 --passminclass=3 

--enablereqlower --disablerequpper --enablereqdigit 

--enablereqother --update

=============================================================

EOF

# Check the minimum password length
min_length=$(grep "^password.*required.*pam_cracklib.so.*minlen" /etc/pam.d/common-password | awk '{print $4}')
if [ $min_length -ge 8 ]; then
    OK "최소 암호 길이가 8 이상으로 설정됨"
else
    WARN "최소 암호 길이가 8 이상으로 설정되지 않음"
fi

# Check if the use of uppercase and special characters is required
if grep -q "^password.*required.*pam_cracklib.so.*ucredit" /etc/pam.d/common-password && grep -q "^password.*required.*pam_cracklib.so.*dcredit" /etc/pam.d/common-password; then
    ok "영문 문자, 숫자, 특수 문자의 최소 입력 기능이 설정되었습니다."
else
    WARN "영문 문자, 숫자, 특수 문자의 최소 입력 기능이 설정되지 않았습니다."
fi


 

cat $result

echo ; echo
