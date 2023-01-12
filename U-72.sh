#!/bin/bash

 

. function.sh

 
TMP1=`SCRIPTNAME`.log

> $TMP1 
 

BAR

CODE [U-72] 정책에 따른 시스템 로깅 설정

cat << EOF >> $result

[양호]: 로그 기록 정책이 정책에 따라 설정되어 수립되어 있는 경우

[취약]: 로그 기록 정책이 정책에 따라 설정되어 수립되어 있지 않은 경우

EOF

BAR

# Define log file locations
log_files=(
    "/var/log/secure"
    "/var/log/messages"
    "/var/log/audit/audit.log"
    "/var/log/httpd/access_log"
    "/var/log/httpd/error_log"
)

# Define log configuration file locations
conf_files=(
    "/etc/rsyslog.conf"
    "/etc/syslog.conf"
    "/etc/httpd/conf/httpd.conf"
    "/etc/audit/auditd.conf"
)

# Check if log files exist
for file in "${log_files[@]}"; do
    if [ -f $file ]; then
        OK "$file 이 존재합니다."
    else
        WARN "$file 이 존재하지 않습니다"
    fi
done

# Check if log configuration files exist
for file in "${conf_files[@]}"; do
    if [ -f $file ]; then
        OK "$file 이 존재합니다."
    else
        WARN "$file 이 존재하지 않습니다"
    fi
done





cat $result

echo ; echo 

 
