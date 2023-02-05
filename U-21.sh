#!/bin/bash

 

. function.sh

 

TMP1=`SCRIPTNAME`.log

> $TMP1

TMP2=/tmp/tmp2

> $TMP2

 

BAR

CODE [U-21] r 계열 서비스 비활성화

cat << EOF >> $result

[양호]: r 계열 서비스가 비활성화 되어 있는 경우

[취약]: r 계열 서비스가 활성화 되어 있는 경우

EOF

BAR



# rlogin 파일 확인
if grep -q "disable\s*=\s*yes" /etc/xinetd.d/rlogin; then
  OK "rlogin 파일에 'disable = yes' 설정이 있습니다."
else
  WARN "rlogin 파일에 'disable = yes' 설정이 없습니다."
fi

# rsh 파일 확인
if grep -q "disable\s*=\s*yes" /etc/xinetd.d/rsh; then
  OK "rsh 파일에 'disable = yes' 설정이 있습니다."
else
  WARN "rsh 파일에 'disable = yes' 설정이 없습니다."
fi

# rexec 파일 확인
if grep -q "disable\s*=\s*yes" /etc/xinetd.d/rexec; then
  OK "exec 파일에 'disable = yes' 설정이 있습니다."
else
  WARN "exec 파일에 'disable = yes' 설정이 없습니다."
fi


 


 

cat $result

echo ; echo