#!/bin/bash

 

. function.sh

 

 

BAR

CODE [U-43] 로그의 정기적 검토 및 보고

cat << EOF >> $U43

[양호]: 로그 기록의 검토, 분석, 리포트 작성 및 보고 등이 정기적으로 이루어지는 경우

[취약]: 로그 기록의 검토, 분석, 리포트 작성 및 보고 등이 정기적으로 이루어지지 않는 경우는 경우

EOF

BAR


# Set the log file path
log_file="/var/log/system.log"

# Check if the log file exists
if [ ! -f $log_file ]; then
    WARN "시스템 로그 파일을 찾을 수 없습니다"
else
    # Check if the log file is updated within the last 7 days
    if test $(find $log_file -mtime -7); then
        OK "시스템 로그 파일이 최근 7일 이내에 업데이트되고 로그 기록이 정기적으로 검토되고 있습니다."
    else
        WARN "지난 7일 이내에 시스템 로그 파일이 업데이트되지 않았습니다. 로그 기록이 정기적으로 검토되지 않을 수 있습니다."
    fi

    # Use grep to check if log analysis and reporting is performed
    result=$(grep -E "^[ \t]*Log analysis and reporting performed" $log_file)

    if [ -n "$result" ]; then
        OK "로그 분석 및 보고 수행했습니다."
    else
        WARN "로그 분석 및 보고가 수행되지 않을 수 있습니다"
    fi
fi

cat $U43

echo ; echo 


 
