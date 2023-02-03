#!/bin/bash

 

. function.sh


TMP1=`SCRIPTNAME`.log

> $TMP1  

BAR

CODE [U-47] 패스워드 최대 사용기간 설정

cat << EOF >> $result

[양호]: 패스워드 최대 사용기간이 90일(12주) 이하로 설정되어 있는 경우

[취약]: 패스워드 최대 사용기간이 90일(12주) 이하로 설정되어 있지 않은 경우

EOF

BAR


# 암호 최대 사용 기간 가져오기
max_age=$(grep -i "^password.*maximum.*age" /etc/login.defs | awk '{print $NF}')

#일 단위로 환산하여 주 단위로 환산하다
max_age_weeks=$((max_age/7))

# 암호 최대 사용 기간이 12주 미만인지 확인합니다
if [ "$max_age_weeks" -lt 12 ]; then
  WARN "Error: 암호 최대 사용 기간이 12주 미만: $max_age_weeks"
fi

# 스크립트가 이 지점에 도달하면 암호 최대 사용 기간이 12주 이상입니다
OK "암호 최대 사용 기간이 12주 이상임: $max_age_weeks"


 

 

cat $result

echo ; echo
