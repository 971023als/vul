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


# Get the password maximum age
max_age=$(grep -i "^password.*maximum.*age" /etc/login.defs | awk '{print $NF}')

#convert the value in days to weeks
max_age_weeks=$((max_age/7))

# Check if the password maximum age is less than 12 weeks
if [ "$max_age_weeks" -lt 12 ]; then
  WARN "Error: 암호 최대 사용 기간이 12주 미만: $max_age_weeks"
fi

# If the script reaches this point, the password maximum age is greater than or equal to 12 weeks
OK "암호 최대 사용 기간이 12주 이상임: $max_age_weeks"


 

 

cat $result

echo ; echo
