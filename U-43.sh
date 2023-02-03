#!/bin/bash

 

. function.sh

TMP1=`SCRIPTNAME`.log

> $TMP1 

 

BAR

CODE [U-43] 로그의 정기적 검토 및 보고

cat << EOF >> $result

[양호]: 로그 기록의 검토, 분석, 리포트 작성 및 보고 등이 정기적으로 이루어지는 경우

[취약]: 로그 기록의 검토, 분석, 리포트 작성 및 보고 등이 정기적으로 이루어지지 않는 경우는 경우

EOF

BAR


# su 시도에 관한 로그 검토

# su 명령을 통해 sulog에서 권한 상승 시도 여부를 점검하십시오
allowed_accounts=("root" "bin" "daemon" "adm" "lp" "sync" "shutdown" "halt" "ubuntu" "user")

# sulog에서 su 명령을 통해 권한 상승 시도 확인 중
INFO "sulog에서 su 명령을 통해 권한 상승 시도 확인 중..."
while read line; do
  user=$(echo $line | awk '{print $1}')
  if [[ ! " ${allowed_accounts[@]} " =~ " ${user} " ]]; then
    WARN "사용자별 권한 상승 시도: $user"
  else
    OK "권한 상승 시도가 없습니다."
  fi
done < /var/log/sulog

# 반복적인 로그인 실패에 관한 로그 검토

# 최대 허용 로그인 시도 실패 횟수 정의
max_failures=5

# 로그에서 반복적인 로그인 실패 여부 확인
INFO "로그에서 반복적인 로그인 실패를 확인하는 중..."
failed_logins=$(grep "Failed password" /var/log/auth.log | awk '{print $11}' | sort | uniq -c | awk '{print $1}')
for failures in $failed_logins; do
  if [ $failures -gt $max_failures ]; then
    ip=$(grep "Failed password" /var/log/auth.log | awk '{print $11}' | sort | uniq -c | awk '{if ($1 == "'$failures'") print $2}')
    WARN "IP 주소에서 반복된 로그인 실패: $ip(로그인 실패 시도: $failures)"
  else
    OK "반복된 로그인 실패가 없습니다."
  fi
done


# 로그인 거부에 관한 로그 검토

# 로그 파일 위치
LOG_FILE="/var/log/auth.log"

# 로그 파일에서 로그인 거부 메시지 검색
grep "authentication failure" $LOG_FILE



cat $result

echo ; echo


 
