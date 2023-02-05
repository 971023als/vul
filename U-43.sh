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

# xferlog 파일의 위치
xferlog_file='/var/log/xferlog'

# 무단 액세스에 대한 항목 필터링
grep 'FTP login failure' $xferlog_file

# 필터링된 항목 표시
INFO "인증되지 않은 FTP 액세스 시도:"
cat filtered_logs.txt




cat $result

echo ; echo


 
