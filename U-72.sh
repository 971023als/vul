#!/bin/bash

 

. function.sh

 

 

BAR

CODE [U-72] 정책에 따른 시스템 로깅 설정

cat << EOF >> $U72

[양호]: 로그 기록 정책이 정책에 따라 설정되어 수립되어 있는 경우

[취약]: 로그 기록 정책이 정책에 따라 설정되어 수립되어 있지 않은 경우

EOF

BAR


# Define the log files to check
log_files=(/var/log/auth.log /var/log/secure /var/log/syslog)

# Define the security policies to check
policies=("log all authentication attempts" "log all system-level access" "log all user-level access")

# Check if log recording policies have been established
for file in "${log_files[@]}"; do
    if [ ! -f $file ]; then
        echo "$file에 대해 설정된 로그 기록 정책이 없습니다"
    else
        echo "$file에 대해 설정된 로그 기록 정책이 있습니다"
    fi
done

# Check if logs are being left in compliance with established security policies
for policy in "${policies[@]}"; do
    if grep -q "$policy" /etc/rsyslog.conf; then
        echo "로그가 $policy를 준수하도록 남겨지고 있습니다."
    else
        echo "로그가 $policy를 준수하여 남아 있지 않습니다."
    fi
done


cat $U72

echo ; echo 

 
